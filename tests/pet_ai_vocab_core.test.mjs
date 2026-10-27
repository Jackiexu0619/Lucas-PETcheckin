import test from 'node:test';
import assert from 'node:assert/strict';
import {DAILY_BASE_QUESTIONS,DAILY_MAX_QUESTIONS,focusFromEvidence,decideFollowup,validateGeneratedQuestions} from '../pet_ai_vocab_core.mjs';

test('fixed daily budget is three base and at most five total', () => {
  assert.equal(DAILY_BASE_QUESTIONS, 3);
  assert.equal(DAILY_MAX_QUESTIONS, 5);
  assert.deepEqual(decideFollowup([{correct:true},{correct:true},{correct:true}]), {finish:true,extraCount:0,targetSkills:[]});
  const result=decideFollowup([{correct:false,skill:'collocation'},{correct:false,skill:'word_meaning'},{correct:true}]);
  assert.equal(result.extraCount, 2);
  assert.equal(decideFollowup([{correct:false,skill:'x'},{correct:false,skill:'y'},{correct:true}],2).extraCount,0);
});

test('selection uses real 7/30-day evidence and keeps original inputs unmodified', () => {
  const now=new Date('2026-10-27T12:00:00Z');
  const words=[{en:'study',mastery:'unstable',review:{due:0}},{en:'go',mastery:'mastered',review:{due:0}}];
  const before=JSON.stringify(words);
  const priorities=focusFromEvidence({words,tests:[
    {en:'study',itemType:'word',ts:new Date('2026-10-26').getTime(),result:'wrong'},
    {en:'go',itemType:'word',ts:new Date('2026-10-26').getTime(),result:'correct'}
  ]},now);
  assert.equal(priorities[0].label,'study');
  assert.equal(priorities[0].wrong7d,1);
  assert.equal(JSON.stringify(words),before);
});

test('generated questions must have validated multiple-choice keys and unique stems', () => {
  const good=(question)=>({type:'choice',skill:'look after',question,options:['care for','look up','leave'],correctIndex:0,explanation:'look after means care for'});
  assert.equal(validateGeneratedQuestions([good('a'),good('b'),good('c')]).ok,true);
  assert.equal(validateGeneratedQuestions([good('a'),good('a'),good('c')]).ok,false);
  assert.equal(validateGeneratedQuestions([good('a')]).ok,false);
  assert.equal(validateGeneratedQuestions([{...good('a'),correctIndex:9},good('b'),good('c')]).ok,false);
});
