/**
 * Lucas PET vocabulary-only adaptive practice core.
 * Pure functions: no browser, network, persistence or Supabase mutations.
 *
 * Generated questions are candidates and must be validated before being saved
 * and shown. The final score belongs to the student answer, never the AI.
 */
export const DAILY_BASE_QUESTIONS = 3;
export const DAILY_MAX_QUESTIONS = 5;
export const EXTRA_LIMIT = DAILY_MAX_QUESTIONS - DAILY_BASE_QUESTIONS;

const asDate = (value) => {
  const date = new Date(value);
  return Number.isFinite(date.getTime()) ? date : null;
};
const canonical = (value) => String(value ?? '').trim().toLocaleLowerCase('en');
const recent = (timestamp, now, days) => {
  const d = asDate(timestamp);
  return d !== null && now.getTime() - d.getTime() >= 0 && now.getTime() - d.getTime() <= days * 86400000;
};
export function focusFromEvidence({ words = [], structures = [], tests = [], retests = [] } = {}, now = new Date()) {
  const byKey = new Map();
  for (const [kind, entries] of [['word', words], ['structure', structures]]) {
    for (const entry of entries) {
      const label = kind === 'word' ? entry.en : entry.title;
      if (!label) continue;
      const key = kind + ':' + canonical(label);
      if (byKey.has(key)) continue;
      const due = Number(entry.review?.due);
      byKey.set(key, {
        key, kind, label,
        mastery: entry.mastery || 'unmastered',
        due: Number.isFinite(due) && due > 0 && due <= now.getTime(),
        wrong7d: 0, wrong30d: 0, slow30d: 0, recentAttempts: 0, pendingRetest: false
      });
    }
  }
  for (const t of tests) {
    const key = (t.itemType === 'structure' ? 'structure:' : 'word:') + canonical(t.en);
    const target = byKey.get(key);
    if (!target || !recent(t.ts, now, 30)) continue;
    target.recentAttempts++;
    const isWrong = t.result === 'wrong';
    if (isWrong) { target.wrong30d++; if (recent(t.ts, now, 7)) target.wrong7d++; }
    if (t.result === 'slow') target.slow30d++;
  }
  for (const retest of retests) {
    const k = retest.key;
    const target = byKey.get(k);
    if (target && retest.status === 'pending' && asDate(retest.dueAt)?.getTime() <= now.getTime()) target.pendingRetest = true;
  }
  return [...byKey.values()].map(x => ({
    ...x,
    // Scores are transparent priority hints; do not turn them into fake mastery.
    priority: x.wrong7d * 8 + x.wrong30d * 3 + x.slow30d * 2 +
      (x.pendingRetest ? 12 : 0) + (x.due ? 2 : 0) +
      (x.mastery === 'unmastered' ? 8 : x.mastery === 'unstable' ? 4 : 0)
  })).sort((a,b) => b.priority - a.priority || a.key.localeCompare(b.key));
}
export function decideFollowup(answers, priorExtraCount = 0) {
  if (!Array.isArray(answers) || answers.length < DAILY_BASE_QUESTIONS)
    throw new Error('Need three graded answers before follow-up');
  const wrong = answers.filter(a => a.correct === false);
  const uncertain = answers.filter(a => a.correct === true && a.uncertain === true);
  const available = Math.max(0, EXTRA_LIMIT - priorExtraCount);
  return {
    finish: available === 0 || (wrong.length === 0 && uncertain.length === 0),
    extraCount: Math.min(available, wrong.length >= 2 ? 2 : (wrong.length || uncertain.length ? 1 : 0)),
    targetSkills: [...new Set([...wrong, ...uncertain].map(a => a.skill).filter(Boolean))].slice(0, 2)
  };
}
export function validateGeneratedQuestions(questions, expectedCount = DAILY_BASE_QUESTIONS) {
  if (!Array.isArray(questions) || questions.length !== expectedCount) return {ok:false,error:'count'};
  const stems = new Set();
  for (const [index, q] of questions.entries()) {
    if (!q || !['choice','cloze'].includes(q.type)) return {ok:false,error:'type',index};
    if (!q.skill || !String(q.question||'').trim() || !String(q.explanation||'').trim()) return {ok:false,error:'missing fields',index};
    if (!Array.isArray(q.options) || q.options.length < 3 || q.options.length > 4) return {ok:false,error:'options',index};
    if (new Set(q.options.map(canonical)).size !== q.options.length || q.options.some(v=>!String(v).trim())) return {ok:false,error:'duplicate options',index};
    if (!Number.isInteger(q.correctIndex) || q.correctIndex < 0 || q.correctIndex >= q.options.length) return {ok:false,error:'answer index',index};
    const stem = canonical(q.question).replace(/\s+/g, ' ');
    if (stems.has(stem)) return {ok:false,error:'duplicate question',index};
    stems.add(stem);
  }
  return {ok:true};
}
