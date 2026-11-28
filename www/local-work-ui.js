/* MASTER WORLD VIP — no-money local work UI.
 * Payment, wallet, payout and refund features are intentionally absent.
 */
(()=>{'use strict';
 const client=()=>window.mwvipGetClient?.()||null;
 const style=document.createElement('style');
 style.textContent='.mwlocal{margin-top:16px;padding:15px;border:1px solid #8b692b;border-radius:15px;background:linear-gradient(145deg,#15171d,#090a0d);color:#fff4d8}.mwlocal h3{color:#f4ce75;margin:0 0 10px}.mwlocal small{color:#c8c0ad}.mwlocal .mwrow{padding:10px;margin:8px 0;border:1px solid #594522;border-radius:10px;background:#ffffff08;overflow-wrap:anywhere}.mwlocal .mwstatus{padding:9px;border-radius:9px;background:#1c2631;margin:9px 0;font-size:12px}.mwlocal textarea,.mwlocal select{width:100%;margin:6px 0;padding:10px;border:1px solid #66512c;border-radius:9px;background:#0b111a;color:#fff}.mwlocal button{margin:5px 5px 5px 0;padding:8px 12px;border:1px solid #b58a38;border-radius:9px;background:#322713;color:#ffe3a0;font-weight:750}.mwlocal button:disabled{opacity:.5}.mwlocal pre{white-space:pre-wrap;overflow-wrap:anywhere;font-size:11px;color:#d7e5d5}';
 document.head.append(style);
 const esc=(v)=>String(v??'');
 const make=(tag,cls,text)=>{const e=document.createElement(tag);if(cls)e.className=cls;if(text!==undefined)e.textContent=text;return e;};
 const id=()=>crypto.randomUUID?.()||('mwvip-'+Date.now()+'-'+Math.random().toString(36).slice(2));
 function adminPanel(){
  const host=document.getElementById('adminDashboard');if(!host||host.querySelector('#mwLocalAdmin'))return;
  const panel=make('section','mwlocal');panel.id='mwLocalAdmin';
  const title=make('h3','', '🧰 No-money Local Work Queue');
  const note=make('small','', 'Admin কাজ তৈরি করবেন; Worker Text/JSON/CSV প্রসেস করবে; Member ফলাফল যাচাই করে জমা দেবে। কোনো টাকা বা পেমেন্ট নেই।');
  const type=make('select');type.id='mwLocalType';
  [['text_cleanup','Text cleanup'],['text_quality_report','Text quality report'],['json_validate','JSON validation'],['csv_validate','CSV validation']].forEach(([v,l])=>{const o=make('option','',l);o.value=v;type.append(o);});
  const input=make('textarea');input.id='mwLocalInput';input.rows=5;input.maxLength=50000;input.placeholder='Text / JSON / CSV input দিন (সর্বোচ্চ ৫০,০০০ অক্ষর)…';
  const create=make('button','', '＋ কাজ তৈরি করুন');create.type='button';
  const refresh=make('button','', '↻ Queue Refresh');refresh.type='button';
  const status=make('div','mwstatus','Admin permission যাচাই হয়নি।');status.id='mwLocalAdminStatus';
  const list=make('div');list.id='mwLocalAdminList';
  panel.append(title,note,type,input,create,refresh,status,list);host.append(panel);
  async function load(){
   const c=client();if(!c){status.textContent='Admin কাজ দেখতে লগইন করুন।';return;}
   try{
    const {data,error}=await c.rpc('admin_list_local_work_tasks');if(error)throw error;
    list.replaceChildren();
    (data||[]).forEach(task=>{
     const row=make('div','mwrow');
     row.append(make('strong','',esc(task.task_type)+' · '+esc(task.status)));
     row.append(make('div','', 'Task: '+esc(task.id)));
     row.append(make('small','', 'তৈরি: '+esc(task.created_at)+' · Member: '+esc(task.assigned_member_id||'এখনো claim হয়নি')));
     if(task.worker_result&&Object.keys(task.worker_result).length)row.append(make('pre','',JSON.stringify(task.worker_result,null,2)));
     if(task.member_submission&&Object.keys(task.member_submission).length)row.append(make('pre','',JSON.stringify(task.member_submission,null,2)));
     if(task.status==='submitted'){
      const yes=make('button','','✓ গ্রহণ করুন');yes.type='button';
      yes.addEventListener('click',async()=>{yes.disabled=true;try{const r=await c.rpc('admin_review_local_work_task',{p_task_id:task.id,p_accept:true,p_review_note:'Admin accepted'});if(r.error)throw r.error;status.textContent='কাজ গ্রহণ করা হয়েছে।';await load();}catch(e){status.textContent='Review ব্যর্থ: '+e.message;yes.disabled=false;}});
      const redo=make('button','','↻ পুনরায় কাজ');redo.type='button';
      redo.addEventListener('click',async()=>{redo.disabled=true;try{const r=await c.rpc('admin_review_local_work_task',{p_task_id:task.id,p_accept:false,p_review_note:'Please revise and resubmit'});if(r.error)throw r.error;status.textContent='কাজ সংশোধনের জন্য ফেরত গেছে।';await load();}catch(e){status.textContent='Review ব্যর্থ: '+e.message;redo.disabled=false;}});
      row.append(yes,redo);
     }
     list.append(row);
    });
    if(!data?.length)list.append(make('div','mwrow','এখনো কোনো কাজ তৈরি হয়নি।'));
    status.textContent='Admin queue নিরাপদভাবে লোড হয়েছে। মোট '+(data?.length||0)+'টি কাজ।';
   }catch(e){status.textContent='Queue এখনো প্রস্তুত নয়: '+e.message;}
  }
  create.addEventListener('click',async()=>{
   const c=client(),value=input.value.trim(),kind=type.value;
   if(!c){status.textContent='কাজ তৈরি করতে Admin হিসেবে লগইন করুন।';return;}
   if(!value){status.textContent='কাজের ইনপুট লিখুন।';return;}
   let payload=kind==='json_validate'?{json_text:value}:kind==='csv_validate'?{csv_text:value}:{text:value};
   create.disabled=true;
   try{const r=await c.rpc('admin_enqueue_local_work_task',{p_task_type:kind,p_payload:payload,p_idempotency_key:id()});if(r.error)throw r.error;input.value='';status.textContent='কাজ Queue-তে যোগ হয়েছে। Worker চালু থাকলে প্রসেস করবে।';await load();}
   catch(e){status.textContent='কাজ তৈরি হয়নি: '+e.message;}
   finally{create.disabled=false;}
  });
  refresh.addEventListener('click',load);
  load();
 }
 function memberPanel(){
  const host=document.getElementById('memberDashboard');if(!host||host.querySelector('#mwLocalMember'))return;
  const panel=make('section','mwlocal');panel.id='mwLocalMember';
  panel.append(make('h3','','💼 Member Work Desk'),make('small','','এখানে পাওয়া কাজ claim করে ফলাফল যাচাই করুন এবং Admin-এর কাছে জমা দিন। এটি কাজের ব্যবস্থা; কোনো আয়/পেমেন্ট প্রতিশ্রুতি নয়।'));
  const claim=make('button','','＋ পরবর্তী কাজ Claim');claim.type='button';
  const refresh=make('button','','↻ আমার কাজ');refresh.type='button';
  const status=make('div','mwstatus','Member account দিয়ে লগইন করুন।');
  const list=make('div');
  panel.append(claim,refresh,status,list);host.append(panel);
  async function load(){
   const c=client();if(!c){status.textContent='কাজ দেখতে Member হিসেবে লগইন করুন。';return;}
   try{
    const r=await c.rpc('member_list_local_work_tasks');if(r.error)throw r.error;
    list.replaceChildren();
    (r.data||[]).forEach(task=>{
     const row=make('div','mwrow');
     row.append(make('strong','',esc(task.task_type)+' · '+esc(task.status)));
     row.append(make('div','', 'Task ID: '+esc(task.id)));
     row.append(make('pre','', 'Worker result:\n'+JSON.stringify(task.worker_result||{},null,2)));
     if(task.status==='claimed'){
      const submission=make('textarea');submission.rows=3;submission.placeholder='আপনার যাচাই/সংশোধিত ফলাফল বা মন্তব্য লিখুন…';
      const send=make('button','','জমা দিন');send.type='button';
      send.addEventListener('click',async()=>{send.disabled=true;try{const x=await c.rpc('member_submit_local_work_task',{p_task_id:task.id,p_submission:{member_note:submission.value.trim()}});if(x.error)throw x.error;status.textContent='আপনার কাজ Admin review-এর জন্য জমা হয়েছে।';await load();}catch(e){status.textContent='জমা হয়নি: '+e.message;send.disabled=false;}});
      row.append(submission,send);
     } else if(task.status==='accepted')row.append(make('small','','Admin কাজ গ্রহণ করেছেন।'));
     else if(task.status==='submitted')row.append(make('small','','Admin review-এর অপেক্ষায়।'));
     list.append(row);
    });
    if(!r.data?.length)list.append(make('div','mwrow','আপনার নামে এখনো কোনো কাজ নেই। পরবর্তী কাজ Claim করুন।'));
    status.textContent='আপনার কাজের তালিকা আপডেট হয়েছে।';
   }catch(e){status.textContent='Member Work Desk এখনো প্রস্তুত নয়: '+e.message;}
  }
  claim.addEventListener('click',async()=>{
   const c=client();if(!c){status.textContent='আগে Member account দিয়ে লগইন করুন।';return;}
   claim.disabled=true;
   try{const r=await c.rpc('member_claim_next_local_work_task');if(r.error)throw r.error;if(!r.data?.length){status.textContent='এই মুহূর্তে নতুন কাজ নেই।';}else status.textContent='একটি কাজ আপনার নামে বরাদ্দ হয়েছে।';await load();}
   catch(e){status.textContent='কাজ Claim হয়নি: '+e.message;}
   finally{claim.disabled=false;}
  });
  refresh.addEventListener('click',load);
  load();
 }
 function install(){adminPanel();memberPanel();}
 if(document.readyState==='loading')document.addEventListener('DOMContentLoaded',install,{once:true});else install();
 const observer=new MutationObserver(install);observer.observe(document.body,{childList:true,subtree:true});
 setTimeout(()=>observer.disconnect(),10000);
})();