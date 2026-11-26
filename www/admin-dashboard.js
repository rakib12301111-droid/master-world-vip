/* MASTER WORLD VIP — server-authorized Admin Dashboard (read-only foundation)
 * All role decisions and data access are enforced by Supabase RPCs/RLS.
 * This UI never grants roles or enables project execution.
 */
(()=>{'use strict';
 const $=id=>document.getElementById(id);
 const getClient=()=>window.mwvipGetClient?.()||null;
 const getUser=()=>window.mwvipGetUser?.()||null;
 let role='guest',checking=false;
 const style=document.createElement('style');
 style.textContent='.mwa{border:1px solid #8d6a2d;border-radius:16px;padding:16px;background:linear-gradient(145deg,#15171d,#090a0d);color:#f7f0df}.mwa h2,.mwa h3{color:#f4ce75}.mwa-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(145px,1fr));gap:10px;margin:12px 0}.mwa-stat{border:1px solid #65502a;border-radius:12px;padding:12px;background:#ffffff08}.mwa-stat b{display:block;font-size:23px;color:#f4ce75}.mwa-muted{color:#c8c0ad;font-size:12px}.mwa-list{max-height:340px;overflow:auto;border:1px solid #514326;border-radius:10px;padding:8px}.mwa-row{padding:8px;border-bottom:1px solid #ffffff18;font-size:12px;overflow-wrap:anywhere}.mwa-status{padding:10px;border-radius:10px;background:#1d2630;margin:10px 0;font-size:13px}';
 document.head.append(style);
 const nav=document.querySelector('.nav');
 if(nav&&!nav.querySelector('[data-page="adminDashboard"]')){
  const b=document.createElement('button');b.type='button';b.dataset.page='adminDashboard';b.textContent='🛡️ Admin Dashboard';b.hidden=true;
  b.addEventListener('click',()=>window.showPage?.('adminDashboard'));
  nav.insertBefore(b,nav.firstChild);
 }
 const main=document.querySelector('main.main');
 if(main&&!$('adminDashboard')){
  const page=document.createElement('section');page.className='page';page.id='adminDashboard';
  page.innerHTML='<div class="mwa"><h2>🛡️ MASTER WORLD VIP — Admin Dashboard</h2><p class="mwa-muted">Server-verified access · Read-only project and automation overview</p><div class="mwa-status" id="mwaAccess" role="status">Admin permission যাচাই হচ্ছে…</div><div class="mwa-grid"><div class="mwa-stat"><span class="mwa-muted">মোট পরিকল্পিত Project</span><b id="mwaTotal">—</b></div><div class="mwa-stat"><span class="mwa-muted">USD Project</span><b id="mwaUsd">—</b></div><div class="mwa-stat"><span class="mwa-muted">BDT Project</span><b id="mwaBdt">—</b></div><div class="mwa-stat"><span class="mwa-muted">Execution readiness</span><b id="mwaReady">—</b></div></div><h3>Project Registry (সারাংশ)</h3><div class="mwa-list" id="mwaProjects">তথ্য লোড হয়নি।</div><h3>Worker Status</h3><div class="mwa-list" id="mwaWorkers">তথ্য লোড হয়নি।</div><h3>গত ৭ দিনের Task Queue</h3><div class="mwa-list" id="mwaTasks">তথ্য লোড হয়নি।</div><div class="mwa-status" id="mwaNote">এই প্যানেল শুধু সার্ভার থেকে অনুমোদিত তথ্য পড়ে। Worker Service চালু বা Project execution এখানে সক্রিয় করা হয় না।</div><button class="btn secondary" id="mwaRefresh" type="button">↻ নিরাপদে Refresh</button></div>';
  main.append(page);
 }
 function line(host,text){const el=document.createElement('div');el.className='mwa-row';el.textContent=text;host.append(el);}
 async function refresh(){
  const client=getClient(),user=getUser(),status=$('mwaAccess');
  if(!client||!user){role='guest';if(status)status.textContent='Admin Dashboard দেখতে আগে লগইন করুন।';return false;}
  if(checking)return false;checking=true;
  try{
   const {data,error}=await client.rpc('get_my_admin_access');if(error)throw error;
   role=String(data||'member');
   const allowed=['owner','super_admin','admin'].includes(role);
   const navButton=document.querySelector('[data-page="adminDashboard"]');if(navButton)navButton.hidden=!allowed;
   const legacy=document.querySelector('[data-page="admin"]');if(legacy)legacy.hidden=!allowed;
   if(status)status.textContent=allowed?'Access verified by Supabase · Role: '+role:'সাধারণ Member account — Admin access নেই।';
   if(!allowed)return false;
   const result=await client.rpc('admin_project_automation_overview');if(result.error)throw result.error;
   const d=result.data||{},projects=Array.isArray(d.projects)?d.projects:[];
   $('mwaTotal').textContent=projects.length.toLocaleString('en-US');
   $('mwaUsd').textContent=projects.filter(p=>p.currency==='USD').length.toLocaleString('en-US');
   $('mwaBdt').textContent=projects.filter(p=>p.currency==='BDT').length.toLocaleString('en-US');
   $('mwaReady').textContent=d.execution_ready===true?'READY':'NOT READY';
   const ph=$('mwaProjects');ph.replaceChildren();
   const byState={};for(const p of projects){const k=String(p.lifecycle_status||'unknown');byState[k]=(byState[k]||0)+1;}
   Object.entries(byState).sort().forEach(([k,v])=>line(ph,k+': '+v));
   if(!projects.length)line(ph,'কোনো Registry row পাওয়া যায়নি; migration status যাচাই করুন।');
   const wh=$('mwaWorkers');wh.replaceChildren();
   (d.workers||[]).forEach(w=>line(wh,String(w.status)+': '+String(w.count)));
   if(!(d.workers||[]).length)line(wh,'কোনো Worker heartbeat/registry record নেই।');
   const th=$('mwaTasks');th.replaceChildren();
   (d.tasks_last_7_days||[]).forEach(t=>line(th,String(t.status)+': '+String(t.count)));
   if(!(d.tasks_last_7_days||[]).length)line(th,'গত ৭ দিনে কোনো Task নেই।');
   $('mwaNote').textContent=d.note||'Control-plane status only. No worker execution is started by this dashboard.';
   return true;
  }catch(e){role='unknown';if(status)status.textContent='Server permission বা Registry RPC যাচাই ব্যর্থ: '+(e.message||String(e));return false;}
  finally{checking=false;}
 }
 const previous=window.showPage;
 if(typeof previous==='function'){
  window.showPage=function(id){
   if(id==='admin'||id==='adminDashboard'){
    if(!['owner','super_admin','admin'].includes(role)){refresh().then(ok=>{if(ok)previous('adminDashboard');else previous('account');});return;}
    previous('adminDashboard');refresh();return;
   }
   return previous(id);
  };
 }
 $('mwaRefresh')?.addEventListener('click',()=>refresh());
 const client=getClient();if(client?.auth?.onAuthStateChange)client.auth.onAuthStateChange(()=>{role='guest';refresh();});
 setTimeout(()=>refresh(),1200);
})();