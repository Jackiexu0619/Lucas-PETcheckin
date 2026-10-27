// Lucas PET daily AI vocabulary practice: independent of formal Review/Test.
const env=(s:string)=>Deno.env.get(s)||'';
const BASE=env('SUPABASE_URL'),ROLE=env('SUPABASE_SERVICE_ROLE_KEY');
const ACCESS=env('PET_AI_ACCESS_TOKEN'),ORIGIN=env('PET_AI_ALLOWED_ORIGIN');
const DS=env('DEEPSEEK_API_URL')||'https://api.deepseek.com/chat/completions';
const MODEL=env('DEEPSEEK_MODEL')||'deepseek-chat',DSKEY=env('DEEPSEEK_API_KEY');
const DAY=/^\d{4}-\d{2}-\d{2}$/;
const dateCN=()=>new Date(Date.now()+8*3600000).toISOString().slice(0,10);
function headers(origin:string|null){return {'Access-Control-Allow-Origin':origin===ORIGIN&&ORIGIN?origin:'null','Access-Control-Allow-Headers':'content-type,x-ai-access','Access-Control-Allow-Methods':'POST,OPTIONS','Content-Type':'application/json; charset=utf-8','Cache-Control':'no-store','Vary':'Origin'};}
function reply(n:number,o:unknown,origin:string|null){return new Response(JSON.stringify(o),{status:n,headers:headers(origin)});}
function equal(a:string,b:string){const x=new TextEncoder().encode(a),y=new TextEncoder().encode(b);let diff=x.length^y.length;for(let i=0;i<Math.max(x.length,y.length);i++)diff|=(x[i]||0)^(y[i]||0);return diff===0;}
async function hash(s:string){const d=await crypto.subtle.digest('SHA-256',new TextEncoder().encode(s));return [...new Uint8Array(d)].map(v=>v.toString(16).padStart(2,'0')).join('');}
async function db(table:string,method:string,query:Record<string,string>,body?:unknown,prefer?:string){
 const u=new URL(BASE+'/rest/v1/'+table);for(const [k,v] of Object.entries(query))u.searchParams.set(k,v);
 const r=await fetch(u,{method,headers:{'apikey':ROLE,'Authorization':'Bearer '+ROLE,'Content-Type':'application/json','Prefer':prefer||'return=representation'},body:body===undefined?undefined:JSON.stringify(body)});
 if(!r.ok)throw Error('database_'+r.status);
 return r.status===204?[]:await r.json();
}
const clip=(v:unknown,n=260)=>String(v??'').slice(0,n).trim();
function valid(questions:any[],count:number){return Array.isArray(questions)&&questions.length===count&&questions.every((q:any)=>q&&['choice','cloze'].includes(q.type)&&clip(q.question).length>=10&&clip(q.skill).length>0&&clip(q.explanation).length>0&&Array.isArray(q.options)&&q.options.length>=3&&q.options.length<=4&&new Set(q.options.map((o:unknown)=>clip(o).toLowerCase())).size===q.options.length&&q.options.every((o:unknown)=>clip(o).length>0)&&Number.isInteger(q.correctIndex)&&q.correctIndex>=0&&q.correctIndex<q.options.length)&&new Set(questions.map(q=>clip(q.question).toLowerCase())).size===count;}
function publicQuestions(q:any[]){return q.map((x,i)=>({id:'q'+(i+1),type:x.type,skill:x.skill,question:x.question,options:x.options}));}
function priority(data:any,history:any[],max=8){
 const items:any[]=[];
 for(const w of data.words||[])if(w?.en)items.push({name:clip(w.en,80),kind:'word',mastery:w.mastery?.e2z||w.status||'unknown',id:w.id});
 for(const w of data.structures||[])if(w?.title)items.push({name:clip(w.title,80),kind:'structure',mastery:w.mastery||'unknown',id:w.id});
 const tests=Array.isArray(data.tests)?data.tests:[];
 const now=Date.now();
 const score=items.map(v=>{
  const recent=tests.filter((t:any)=>t&&(v.kind==='structure'?t.structureId===v.id:t.wordId===v.id)&&Number(t.ts)>now-30*86400000);
  const wrong=recent.filter((t:any)=>t.result==='wrong').length;
  const slow=recent.filter((t:any)=>t.result==='slow').length;
  const past=history.flatMap((r:any)=>r.submitted_answers||[]).filter((x:any)=>x.skill===v.name&&!x.correct).length;
  return {...v,wrong,slow,priority:wrong*8+slow*3+past*4+(v.mastery==='unmastered'?5:v.mastery==='unstable'?3:0)};
 });
 return score.sort((a,b)=>b.priority-a.priority).slice(0,max).map(({name,kind,wrong,slow,mastery})=>({name,kind,wrong,slow,mastery}));
}
async function generate(evidence:any[],count:number,previous:string[]=[]){
 const sys='You make Cambridge B1 English vocabulary/collocation practice for one 10-year-old learner. Use ONLY supplied learned word or collocation targets, natural English, one unambiguous correct option, 3 options per question, short Chinese explanation. Mix multiple-choice and short contextual cloze. Do not reveal solutions inside question. Respond JSON object {"questions":[{"type":"choice|cloze","skill":"exact target name","question":"English sentence/question","options":["A","B","C"],"correctIndex":0,"explanation":"Chinese explanation"}]}. Exactly '+count+' questions. Do not repeat prior stems.';
 if(!DSKEY)throw Error('model_not_configured');
 const controller=new AbortController(),timeout=setTimeout(()=>controller.abort(),28000);
 try{
 const r=await fetch(DS,{method:'POST',headers:{Authorization:'Bearer '+DSKEY,'Content-Type':'application/json'},body:JSON.stringify({model:MODEL,temperature:0.3,max_tokens:1600,response_format:{type:'json_object'},messages:[{role:'system',content:sys},{role:'user',content:JSON.stringify({evidence,avoid:previous.slice(-5)})}]}),signal:controller.signal});
 if(!r.ok)throw Error('model_'+r.status);
 const j=await r.json();const content=j?.choices?.[0]?.message?.content;if(typeof content!=='string')throw Error('model_empty');
 const output=JSON.parse(content.replace(/^```(?:json)?\s*|\s*```$/g,''));if(!valid(output.questions,count))throw Error('invalid_generated_questions');
 const allowed=new Set(evidence.map(x=>x.name));if(!output.questions.every((q:any)=>allowed.has(q.skill)))throw Error('outside_learner_vocabulary');
 return output.questions.map((q:any)=>({type:q.type,skill:clip(q.skill,80),question:clip(q.question,460),options:q.options.map((v:any)=>clip(v,150)),correctIndex:q.correctIndex,explanation:clip(q.explanation,500)}));
 }finally{clearTimeout(timeout)}
}
Deno.serve(async req=>{
 const origin=req.headers.get('origin');
 if(req.method==='OPTIONS')return new Response(null,{status:204,headers:headers(origin)});
 if(req.method!=='POST')return reply(405,{error:'method'},origin);
 if(!ORIGIN||origin!==ORIGIN)return reply(403,{error:'origin'},origin);
 if(!ACCESS||ACCESS.length<24||!equal(req.headers.get('x-ai-access')||'',ACCESS))return reply(401,{error:'access'},origin);
 if(!BASE||!ROLE)return reply(503,{error:'backend'},origin);
 let x:any;try{const raw=await req.text();if(raw.length>3000)return reply(413,{error:'size'},origin);x=JSON.parse(raw);}catch{return reply(400,{error:'json'},origin)}
 if(x.action==='status')return reply(200,{ok:true,ready:!!DSKEY,mode:'staging',maxQuestions:5},origin);
 if(!DAY.test(x.date||'')||x.date!==dateCN())return reply(400,{error:'date_must_be_today_china'},origin);
 if(!x.recovery_key||String(x.recovery_key).length<24)return reply(401,{error:'missing_profile_key'},origin);
 try{
  const recoveryHash=await hash(x.recovery_key);
  const profiles=await db('pet_profiles','GET',{select:'id',recovery_hash:'eq.'+recoveryHash,limit:'1'});
  if(profiles.length!==1)return reply(404,{error:'profile_not_found'},origin);
  const profile=profiles[0].id;
  const query={select:'*',profile_id:'eq.'+profile,session_date:'eq.'+x.date,limit:'1'};
  const existing=await db('pet_ai_daily_practice','GET',query);
  if(x.action==='questions'){
   if(existing.length){const row=existing[0];return reply(200,{ok:true,date:x.date,questions:publicQuestions([...row.base_questions,...row.extra_questions]),answerCount:row.submitted_answers.length,completed:row.submitted_answers.length>=row.base_questions.length+row.extra_questions.length},origin)}
   const states=await db('pet_current_state','GET',{select:'payload',profile_id:'eq.'+profile,limit:'1'});
   if(!states.length)return reply(404,{error:'state_not_found'},origin);
   const previous=await db('pet_ai_daily_practice','GET',{select:'submitted_answers',profile_id:'eq.'+profile,order:'session_date.desc',limit:'30'});
   const evidence=priority(states[0].payload,previous);
   if(!evidence.length)return reply(422,{error:'no_learned_vocabulary'},origin);
   const generated=await generate(evidence,3);
   await db('pet_ai_daily_practice','POST',{},[{profile_id:profile,session_date:x.date,base_questions:generated,focus_evidence:{targets:evidence,source:'cloud_formal_tests'},model:MODEL}],'resolution=ignore-duplicates,return=representation');
   const fresh=await db('pet_ai_daily_practice','GET',query);
   if(!fresh.length)throw Error('plan_not_saved');
   return reply(200,{ok:true,date:x.date,questions:publicQuestions(fresh[0].base_questions),answerCount:0,completed:false},origin);
  }
  if(x.action==='submit'){
   if(existing.length!==1)return reply(404,{error:'plan_not_found'},origin);
   const row=existing[0],all=[...row.base_questions,...row.extra_questions];
   if(row.submitted_answers.length)return reply(409,{error:'already_submitted'},origin);
   if(!Array.isArray(x.answers)||x.answers.length!==3||x.answers.some((v:any)=>!Number.isInteger(v)||v<0||v>3))return reply(400,{error:'answer_shape'},origin);
   const results=row.base_questions.map((q:any,i:number)=>({id:'q'+(i+1),skill:q.skill,selected:x.answers[i],correct:x.answers[i]===q.correctIndex,correctIndex:q.correctIndex,explanation:q.explanation}));
   const wrong=results.filter((v:any)=>!v.correct);
   const count=Math.min(2,wrong.length>=2?2:wrong.length);
   let extra:any[]=[];if(count){try{extra=await generate(row.focus_evidence.targets.filter((t:any)=>wrong.some((v:any)=>v.skill===t.name)),count,row.base_questions.map((q:any)=>q.question))}catch{extra=[]}}
   const changed=await db('pet_ai_daily_practice','PATCH',{profile_id:'eq.'+profile,session_date:'eq.'+x.date,submitted_answers:'eq.[]'},{
     submitted_answers:results,extra_questions:extra,updated_at:new Date().toISOString()
   });
   if(changed.length!==1)return reply(409,{error:'concurrent_submission'},origin);
   return reply(200,{ok:true,correct:results.filter((v:any)=>v.correct).length,graded:results,followupQuestions:extra.map((q:any,i:number)=>({id:'q'+(i+4),type:q.type,skill:q.skill,question:q.question,options:q.options})),done:extra.length===0},origin);
  }
  if(x.action==='submit_extra'){
   if(existing.length!==1)return reply(404,{error:'plan_not_found'},origin);
   const row=existing[0],extras=row.extra_questions;
   if(row.submitted_answers.length!==3)return reply(409,{error:'base_required_or_already_submitted'},origin);
   if(!Array.isArray(extras)||extras.length===0)return reply(409,{error:'no_extra'},origin);
   if(!Array.isArray(x.answers)||x.answers.length!==extras.length||x.answers.some((v:any)=>!Number.isInteger(v)||v<0||v>3))return reply(400,{error:'answer_shape'},origin);
   const added=extras.map((q:any,i:number)=>({id:'q'+(i+4),skill:q.skill,selected:x.answers[i],correct:x.answers[i]===q.correctIndex,correctIndex:q.correctIndex,explanation:q.explanation}));
   const newAnswers=[...row.submitted_answers,...added];
   const changed=await db('pet_ai_daily_practice','PATCH',{
     profile_id:'eq.'+profile,session_date:'eq.'+x.date,submitted_answers:'eq.'+JSON.stringify(row.submitted_answers)
   },{submitted_answers:newAnswers,updated_at:new Date().toISOString()});
   if(changed.length!==1)return reply(409,{error:'concurrent_submission'},origin);
   return reply(200,{ok:true,graded:added,correct:added.filter((v:any)=>v.correct).length,done:true},origin);
  }
  return reply(400,{error:'action'},origin);
 }catch(e){console.error('daily practice',e instanceof Error?e.message:'unknown');return reply(502,{error:'ai_daily_unavailable'},origin)}
});
