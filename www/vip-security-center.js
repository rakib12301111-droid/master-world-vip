/* MASTER WORLD VIP — Premium Security Center (Supabase Auth MFA) */
(()=>{
 const style=document.createElement('style');
 style.textContent=`
 .vip-gold{--vip-gold:#f2c65c;--vip-line:#806127}
 .vip-hero-card{background:linear-gradient(135deg,#17191f,#090a0d 70%);border:1px solid #806127;border-radius:18px;padding:18px;box-shadow:0 12px 30px #0008,inset 0 1px #ffffff12;margin:12px 0}
 .vip-heading{display:flex;align-items:center;gap:12px;color:#ffe19a;font-weight:850;font-size:20px}
 .vip-icon{width:44px;height:44px;display:grid;place-items:center;border-radius:14px;background:linear-gradient(145deg,#6c501b,#17130b);border:1px solid #b88a35;font-size:23px}
 .vip-grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(190px,1fr));gap:10px;margin:14px 0}
 .vip-tile{background:linear-gradient(145deg,#20232a,#111318);border:1px solid #34363b;border-radius:14px;padding:14px;min-width:0}
 .vip-tile b{display:block;color:#fff1c8;margin-bottom:4px}.vip-muted{color:#b9b2a2;font-size:12px}
 .vip-action{border:1px solid #9a742e!important;background:linear-gradient(100deg,#604817,#30230e)!important;color:#ffe6a3!important;border-radius:11px!important;padding:10px 14px!important;font-weight:750}
 .vip-action.secondary{background:#22252c!important;border-color:#494b52!important;color:#eee!important}
 .vip-input{width:100%;padding:11px;border-radius:10px;border:1px solid #5c4b2c;background:#0b0d11;color:#fff;margin:7px 0}
 .vip-status{padding:10px;border-radius:10px;background:#171a20;border:1px solid #46413a;margin-top:10px;font-size:13px;overflow-wrap:anywhere}
 .vip-qr{max-width:230px;width:100%;background:#fff;padding:10px;border-radius:12px;display:block;margin:12px 0}
 @media(max-width:650px){.vip-grid{grid-template-columns:1fr 1fr}.vip-heading{font-size:17px}}
 `;
 document.head.append(style);
 const nav=document.querySelector('.nav');
 if(nav&&!nav.querySelector('[data-page="security"]')){
  const b=document.createElement('button');b.dataset.page='security';b.textContent='🔐 Security Center';nav.insertBefore(b,nav.querySelector('[data-page="privacy"]'));
  b.addEventListener('click',()=>window.showPage?.('security'));
 }
 const admin=document.getElementById('admin');
 if(admin&&!document.getElementById('vipAdminSummary')){
  const box=document.createElement('div');box.id='vipAdminSummary';box.className='vip-hero-card vip-gold';
  box.innerHTML='<div class="vip-heading"><span class="vip-icon">👑</span><span>MASTER WORLD VIP · ADMIN CONTROL</span></div><p class="vip-muted">Owner → Super Admin → Admin → Moderator → Member · Server-side permission only</p><div class="vip-grid"><div class="vip-tile"><b>👥 Member Management</b><span class="vip-muted">Existing role controls and member tools</span></div><div class="vip-tile"><b>🛡 Verification & Reports</b><span class="vip-muted">Review queues depend on backend tables and policies</span></div><div class="vip-tile"><b>📢 Broadcast Center</b><span class="vip-muted">Uses the existing protected broadcast function</span></div><div class="vip-tile"><b>📋 Audit Logs</b><span class="vip-muted">Visible only when server-side role permits access</span></div></div><button class="vip-action" id="vipOpenSecurity">Open Security Center →</button>';
  admin.querySelector('article')?.prepend(box);
  box.querySelector('#vipOpenSecurity')?.addEventListener('click',()=>document.querySelector('[data-page="security"]')?.click());
 }
 const privacy=document.getElementById('privacy');
 if(privacy&&!document.getElementById('vipPrivacySummary')){
  const box=document.createElement('div');box.id='vipPrivacySummary';box.className='vip-hero-card vip-gold';
  box.innerHTML='<div class="vip-heading"><span class="vip-icon">🛡️</span><span>PRIVACY CONTROL CENTER</span></div><div class="vip-grid"><div class="vip-tile"><b>🔒 Essential Security</b><span class="vip-muted">Always required for account protection</span></div><div class="vip-tile"><b>📊 Optional Consent</b><span class="vip-muted">Analytics, personalization and notifications remain opt-in</span></div><div class="vip-tile"><b>📥 Data Requests</b><span class="vip-muted">Access, correction and deletion requests are queued for review</span></div></div>';
  privacy.querySelector('article')?.prepend(box);
 }
 const main=document.querySelector('main.main');
 if(main&&!document.getElementById('security')){
  const page=document.createElement('section');page.className='page';page.id='security';
  page.innerHTML='<article class="card"><div class="vip-hero-card vip-gold"><div class="vip-heading"><span class="vip-icon">🔐</span><span>SECURITY CENTER</span></div><p class="vip-muted">Protect your account · Secure authentication · Device sessions</p></div><div class="vip-grid"><div class="vip-tile"><b>🔑 Two-Factor Authentication</b><span class="vip-muted" id="vipMfaState">Checking account factors…</span><div id="vipMfaFactors"></div><button class="vip-action" id="vipMfaEnroll">Set up authenticator</button></div><div class="vip-tile"><b>📱 Active Session Control</b><span class="vip-muted">Sign out this account from all sessions, including other devices.</span><button class="vip-action secondary" id="vipGlobalSignout">Sign out all devices</button></div><div class="vip-tile"><b>📲 Trusted Devices</b><span class="vip-muted">Register this browser and manage devices you have marked trusted.</span><button class="vip-action" id="vipRegisterDevice">Trust this device</button><div id="vipDevicesList" class="vip-status">Log in to view devices.</div></div><div class="vip-tile"><b>🕘 Login History</b><span class="vip-muted">Recent sign-ins observed by this app.</span><button class="vip-action secondary" id="vipRefreshHistory">Refresh history</button><div id="vipLoginHistory" class="vip-status">Log in to view history.</div></div><div class="vip-tile"><b>🚨 Security Alerts</b><span class="vip-muted">Keep your email secure and review Supabase authentication notices.</span></div></div><div class="vip-tile"><b>Authenticator setup</b><p class="vip-muted">Use an authenticator app. Scan the QR code and enter its current 6-digit code to verify. Never share this code with anyone.</p><div id="vipMfaEnrollArea"></div><div id="vipMfaStatus" class="vip-status" role="status">Log in to manage two-factor authentication.</div></div><div class="vip-status">Security note: Two-factor authentication requires Supabase Auth MFA support and a logged-in account. Device history, trusted-device registry and suspicious-login detection require additional backend tables/functions and are not marked active until deployed and tested.</div></article>';
  main.append(page);
 }
 const $=id=>document.getElementById(id);\n const getClient=()=>window.mwvipGetClient?.()||null;\n const getUser=()=>window.mwvipGetUser?.()||null;
 const status=(s)=>{if($('vipMfaStatus'))$('vipMfaStatus').textContent=s;};
 
 const deviceKey=()=>{
  let key=localStorage.getItem('mwvip_device_key');
  if(!key){key=(crypto.randomUUID?crypto.randomUUID():('mwvip-'+Date.now()+'-'+Math.random().toString(36).slice(2)));localStorage.setItem('mwvip_device_key',key);}
  return key;
 };
 const deviceInfo=()=>({device_key:deviceKey(),device_name:/Android/i.test(navigator.userAgent)?'Android device':/iPhone|iPad/i.test(navigator.userAgent)?'iPhone/iPad':'Web browser',platform:navigator.platform||'Web',user_agent:navigator.userAgent});
 async function registerTrustedDevice(){
  const cl=getClient(),u=getUser();if(!cl||!u){$('vipDevicesList').textContent='আগে লগইন করুন।';return;}
  const d=deviceInfo();
  const {error}=await cl.from('trusted_devices').upsert({user_id:u.id,...d,last_seen_at:new Date().toISOString(),revoked_at:null},{onConflict:'user_id,device_key'});
  if(error)throw error;
  await loadTrustedDevices();
 }
 async function loadTrustedDevices(){
  const cl=getClient(),u=getUser();if(!cl||!u){$('vipDevicesList').textContent='লগইন করুন।';return;}
  const {data,error}=await cl.from('trusted_devices').select('id,device_key,device_name,platform,first_seen_at,last_seen_at,revoked_at').eq('user_id',u.id).is('revoked_at',null).order('last_seen_at',{ascending:false}).limit(20);
  if(error)throw error;
  const root=$('vipDevicesList');root.replaceChildren();
  if(!data?.length){root.textContent='কোনো trusted device নেই। এই ডিভাইসটি যোগ করতে Trust this device চাপুন।';return;}
  data.forEach(d=>{const row=document.createElement('div');row.style.cssText='display:flex;gap:8px;align-items:center;justify-content:space-between;padding:8px 0;border-bottom:1px solid #383838';
   const label=document.createElement('span');label.textContent=d.device_name+' · '+d.platform+(d.device_key===deviceKey()?' · This device':'');row.append(label);
   const btn=document.createElement('button');btn.className='vip-action secondary';btn.textContent='Remove';btn.addEventListener('click',async()=>{if(!confirm('এই trusted device সরাবেন?'))return;const {error:e}=await cl.from('trusted_devices').update({revoked_at:new Date().toISOString()}).eq('id',d.id).eq('user_id',u.id);if(e){root.textContent='সরানো যায়নি: '+e.message;return;}await loadTrustedDevices();});row.append(btn);root.append(row);
  });
 }
 async function recordLogin(eventType){
  const cl=getClient(),u=getUser();if(!cl||!u)return;
  const d=deviceInfo();const {error}=await cl.from('login_history').insert({user_id:u.id,...d,event_type:eventType});
  if(error)console.warn('Login history record failed:',error.message);
 }
 async function loadLoginHistory(){
  const cl=getClient(),u=getUser();if(!cl||!u){$('vipLoginHistory').textContent='লগইন করুন।';return;}
  const {data,error}=await cl.from('login_history').select('id,device_name,platform,event_type,occurred_at').eq('user_id',u.id).order('occurred_at',{ascending:false}).limit(30);
  if(error)throw error;
  const root=$('vipLoginHistory');root.replaceChildren();
  if(!data?.length){root.textContent='এখনো কোনো লগইন রেকর্ড নেই।';return;}
  data.forEach(item=>{const row=document.createElement('div');row.style.cssText='padding:7px 0;border-bottom:1px solid #383838';const date=new Date(item.occurred_at).toLocaleString();row.textContent=date+' · '+item.event_type+' · '+item.device_name+' ('+item.platform+')';root.append(row);});
 }
 async function refreshDevicePanels(){
  try{await Promise.all([loadTrustedDevices(),loadLoginHistory()]);}
  catch(e){if($('vipDevicesList'))$('vipDevicesList').textContent='ডেটাবেস প্রস্তুত হয়নি বা অনুমতি নেই: '+e.message;if($('vipLoginHistory'))$('vipLoginHistory').textContent='ডেটাবেস প্রস্তুত হয়নি বা অনুমতি নেই: '+e.message;}
 }
 async function refreshFactors(){
  if(!getClient()||!getUser()){if($('vipMfaState'))$('vipMfaState').textContent='Log in to check MFA status.';return;}
  try{
   const {data,error}=await getClient().auth.mfa.listFactors();if(error)throw error;
   const verified=(data?.totp||[]).filter(f=>f.status==='verified');
   $('vipMfaState').textContent=verified.length?'Authenticator MFA is enabled.':'Authenticator MFA is not enabled.';
   $('vipMfaFactors').textContent=verified.map(f=>'Verified: '+(f.friendly_name||'Authenticator')).join(' · ');
  }catch(e){$('vipMfaState').textContent='MFA status unavailable: '+e.message;}
 }
 document.addEventListener('click',async e=>{
  if(e.target?.id==='vipMfaEnroll'){
   if(!getClient()||!getUser()){status('আগে অ্যাকাউন্টে লগইন করুন।');return;}
   status('Authenticator enrollment তৈরি হচ্ছে…');
   try{
    const {data,error}=await getClient().auth.mfa.enroll({factorType:'totp',friendlyName:'MASTER WORLD VIP Authenticator'});if(error)throw error;
    const area=$('vipMfaEnrollArea');area.replaceChildren();
    const qr=document.createElement('img');qr.className='vip-qr';qr.alt='Authenticator QR code';qr.src=data.totp.qr_code;area.append(qr);
    const secret=document.createElement('p');secret.className='vip-muted';secret.textContent='Manual setup key: '+data.totp.secret;area.append(secret);
    const input=document.createElement('input');input.className='vip-input';input.inputMode='numeric';input.maxLength=6;input.placeholder='6-digit authenticator code';area.append(input);
    const verify=document.createElement('button');verify.className='vip-action';verify.textContent='Verify & enable MFA';area.append(verify);
    verify.addEventListener('click',async()=>{
     const code=input.value.trim();if(!/^\d{6}$/.test(code)){status('৬ সংখ্যার সঠিক কোড লিখুন।');return;}
     status('কোড যাচাই হচ্ছে…');
     try{const {error:ve}=await getClient().auth.mfa.challengeAndVerify({factorId:data.id,code});if(ve)throw ve;status('Two-factor authentication সফলভাবে চালু হয়েছে।');area.replaceChildren();await refreshFactors();}
     catch(err){status('যাচাই হয়নি: '+err.message);}
    });
    status('QR scan করুন, তারপর authenticator-এর ৬ সংখ্যার কোড দিন।');
   }catch(err){status('MFA setup করা যায়নি: '+err.message);}
  }
  if(e.target?.id==='vipRegisterDevice'){try{status('এই ডিভাইস trusted করা হচ্ছে…');await registerTrustedDevice();status('এই ডিভাইস trusted list-এ যুক্ত হয়েছে।');}catch(err){status('ডিভাইস যুক্ত হয়নি: '+err.message+'। Supabase migration প্রয়োগ হয়েছে কি না দেখুন।');}}
  if(e.target?.id==='vipRefreshHistory'){await refreshDevicePanels();}
  if(e.target?.id==='vipGlobalSignout'){
   if(!getClient()||!getUser()){status('আগে লগইন করুন।');return;}
   if(!confirm('সব ডিভাইস থেকে সাইন আউট করবেন? আপনাকেও আবার লগইন করতে হবে।'))return;
   status('সব session বন্ধ করা হচ্ছে…');
   try{const {error}=await getClient().auth.signOut({scope:'global'});if(error)throw error;status('সব session থেকে sign out করা হয়েছে।');}
   catch(err){status('সব session বন্ধ হয়নি: '+err.message);}
  }
 });
 let observedAuthClient=null;
 function attachSecurityAuthListener(){
  const cl=getClient();if(!cl||cl===observedAuthClient)return;observedAuthClient=cl;
  cl.auth.onAuthStateChange((event,session)=>{
   if(event==='SIGNED_IN'&&session?.user){setTimeout(async()=>{try{await recordLogin('sign_in');await refreshDevicePanels();}catch(err){console.warn('Security login history:',err.message);}},0);}
   if(event==='SIGNED_OUT'){if($('vipDevicesList'))$('vipDevicesList').textContent='লগইন করুন।';if($('vipLoginHistory'))$('vipLoginHistory').textContent='লগইন করুন।';}
  });
 }
 const oldConnect=document.getElementById('connect');
 if(oldConnect)oldConnect.addEventListener('click',()=>setTimeout(refreshFactors,1200));
 const oldLogin=document.getElementById('login');
 if(oldLogin)oldLogin.addEventListener('click',()=>setTimeout(refreshFactors,1200));
 const oldSignup=document.getElementById('signup');
 if(oldSignup)oldSignup.addEventListener('click',()=>setTimeout(refreshFactors,1500));
 const oldPageHandler=window.showPage;
 window.showPage=(id)=>{if(typeof oldPageHandler==='function')oldPageHandler(id);else{document.querySelectorAll('.page').forEach(p=>p.classList.toggle('active',p.id===id));}if(id==='security'){refreshFactors();refreshDevicePanels();attachSecurityAuthListener();}};
 setTimeout(()=>{attachSecurityAuthListener();if(document.getElementById('security')){refreshFactors();refreshDevicePanels();}},900);
})();
/* Load the additive member dashboard without replacing existing app modules. */
(()=>{const s=document.createElement('script');s.src='./member-dashboard.js?v=20261125-1';s.defer=true;document.head.appendChild(s);})();
