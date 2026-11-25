/* MASTER WORLD VIP — Member Premium Dashboard (additive UI) */
(()=>{
 'use strict';
 const $=id=>document.getElementById(id);
 const client=()=>window.mwvipGetClient?.()||null;
 const user=()=>window.mwvipGetUser?.()||null;
 const money=v=>'৳'+Number(v||0).toLocaleString('en-BD',{minimumFractionDigits:2,maximumFractionDigits:2});
 const style=document.createElement('style');
 style.textContent=`
 .mwdash{background:radial-gradient(ellipse at 85% 0%,#4a3510 0,transparent 36%),linear-gradient(145deg,#101116,#050608 75%);border:1px solid #9a742e;border-radius:19px;padding:16px;box-shadow:0 12px 34px #0008;color:#fff8e8}
 .mwdash-head{display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap}
 .mwdash-brand{font-weight:900;letter-spacing:.04em;color:#f5ce69;font-size:clamp(18px,3vw,25px)}
 .mwdash-profile{display:flex;align-items:center;gap:13px;margin:18px 0;padding:14px;border:1px solid #705522;border-radius:15px;background:#ffffff08}
 .mwdash-avatar{width:66px;height:66px;border-radius:50%;object-fit:cover;border:3px solid #e6b94f;background:#1a1a1a;display:grid;place-items:center;font-size:27px}
 .mwdash-name{font-size:19px;font-weight:850;color:#fff}.mwdash-muted{color:#c3b99f;font-size:12px;overflow-wrap:anywhere}
 .mwdash-badge{display:inline-block;border:1px solid #94712e;background:#382b12;color:#ffdf91;border-radius:30px;padding:4px 10px;font-size:11px;font-weight:800}
 .mwdash-stats{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:10px;margin:12px 0}
 .mwdash-stat{background:linear-gradient(145deg,#211d14,#111318);border:1px solid #94712e;border-radius:14px;padding:13px;min-width:0}
 .mwdash-stat small{color:#c9bd9e}.mwdash-stat strong{display:block;color:#f6cf68;font-size:clamp(21px,4vw,29px);margin-top:4px;overflow-wrap:anywhere}
 .mwdash-grid{display:grid;grid-template-columns:repeat(3,minmax(0,1fr));gap:9px;margin:13px 0}
 .mwdash-tile{display:flex;flex-direction:column;align-items:center;justify-content:center;gap:6px;min-height:88px;padding:10px 5px;border:1px solid #685126;border-radius:13px;background:linear-gradient(145deg,#202127,#101116);color:#fff0c7;text-align:center;font-weight:750;font-size:12px;text-decoration:none}
 .mwdash-tile span{font-size:24px;color:#f2c65c}.mwdash-tile:hover{border-color:#f2c65c;background:#282116}
 .mwdash-status{padding:11px;border:1px solid #3d7d43;background:#102516;color:#c5f4c8;border-radius:12px;font-size:12px;margin-top:12px}
 .mwdash-banner{margin-top:12px;border:1px solid #8a692e;border-radius:12px;padding:13px;text-align:center;background:linear-gradient(100deg,#111d2c,#17120a);color:#f8d783;font-weight:800}
 .mwdash-actions{display:flex;gap:8px;flex-wrap:wrap;margin-top:12px}
 @media(max-width:390px){.mwdash-grid{grid-template-columns:repeat(2,minmax(0,1fr))}.mwdash-profile{align-items:flex-start}.mwdash-avatar{width:54px;height:54px}}
 `;
 document.head.append(style);
 const nav=document.querySelector('.nav');
 if(nav&&!nav.querySelector('[data-page="memberDashboard"]')){
  const b=document.createElement('button');b.dataset.page='memberDashboard';b.textContent='👑 Member Dashboard';
  const overview=nav.querySelector('[data-page="overview"]');nav.insertBefore(b,overview||nav.firstChild);
  b.addEventListener('click',()=>window.showPage?.('memberDashboard'));
 }
 const main=document.querySelector('main.main');
 if(main&&!$('memberDashboard')){
  const page=document.createElement('section');page.className='page';page.id='memberDashboard';
  page.innerHTML=`
   <div class="mwdash">
    <div class="mwdash-head"><div><div class="mwdash-brand">👑 MASTER WORLD VIP</div><div class="mwdash-muted">আপনার সদস্য ড্যাশবোর্ড</div></div><span class="mwdash-badge" id="mwdashOnline">● যাচাই হচ্ছে</span></div>
    <div class="mwdash-profile"><img class="mwdash-avatar" id="mwdashAvatar" alt="Member profile" src="./icons/icon.svg"><div style="min-width:0"><div class="mwdash-name" id="mwdashName">সদস্য</div><div class="mwdash-badge">VIP MEMBER</div><div class="mwdash-muted" id="mwdashId">Member ID: —</div><div class="mwdash-muted" id="mwdashEmail">ইমেইল: —</div></div></div>
    <div class="mwdash-stats">
     <div class="mwdash-stat"><small>উত্তোলনযোগ্য ব্যালেন্স</small><strong id="mwdashBalance">—</strong><small id="mwdashWalletNote">সুরক্ষিত ওয়ালেট হিসাব</small></div>
     <div class="mwdash-stat"><small>মোট অর্জিত রেফারেল রিওয়ার্ড</small><strong id="mwdashEarned">—</strong><small>যোগ্য ও অনুমোদিত রিওয়ার্ড</small></div>
    </div>
    <div style="font-weight:850;color:#f5d783;margin:15px 0 7px">মেম্বার সুবিধা</div>
    <div class="mwdash-grid">
     <button class="mwdash-tile" data-mwgo="members"><span>👤</span>প্রোফাইল</button>
     <button class="mwdash-tile" data-mwgo="growth"><span>🔗</span>রেফারেল</button>
     <button class="mwdash-tile" data-mwgo="growth"><span>💳</span>ওয়ালেট</button>
     <button class="mwdash-tile" data-mwgo="inbox"><span>💬</span>মেসেজ</button>
     <button class="mwdash-tile" data-mwgo="location"><span>📍</span>লোকেশন</button>
     <button class="mwdash-tile" data-mwgo="verification"><span>🛡️</span>ভেরিফিকেশন</button>
     <button class="mwdash-tile" data-mwgo="verification"><span>🎧</span>হেল্পলাইন</button>
     <button class="mwdash-tile" data-mwgo="community"><span>👥</span>কমিউনিটি</button>
     <button class="mwdash-tile" data-mwgo="privacy"><span>🔐</span>প্রাইভেসি</button>
     <button class="mwdash-tile" data-mwgo="updates"><span>🔔</span>আপডেট</button>
     <button class="mwdash-tile" data-mwgo="security"><span>🔑</span>সিকিউরিটি</button>
     <button class="mwdash-tile" data-mwgo="settings"><span>⚙️</span>সেটিংস</button>
    </div>
    <div class="mwdash-status" id="mwdashStatus" role="status">আপনার অ্যাকাউন্টের তথ্য লোড হচ্ছে…</div>
    <div class="mwdash-banner">আসসালামু আলাইকুম · MASTER WORLD VIP-এ স্বাগতম</div>
    <div class="mwdash-actions"><button class="btn secondary" id="mwdashRefresh" type="button">↻ তথ্য রিফ্রেশ</button><button class="btn secondary" id="mwdashProfile" type="button">প্রোফাইল সম্পাদনা</button></div>
   </div>
   <p class="muted small">ব্যালেন্স ও রিওয়ার্ড Supabase-এর সদস্য-নিজস্ব wallet function থেকে লোড হয়। Database migration চালু না থাকলে এখানে প্রকৃত হিসাব দেখানো হবে না; কোনো নমুনা টাকা দেখানো হয় না।</p>`;
  main.append(page);
 }
 document.addEventListener('click',e=>{
  const go=e.target.closest('[data-mwgo]');if(go)window.showPage?.(go.dataset.mwgo);
  if(e.target.closest('#mwdashRefresh'))refresh();
  if(e.target.closest('#mwdashProfile'))window.showPage?.('members');
 });
 async function refresh(){
  const u=user(),cl=client();
  if(!u||!cl){$('mwdashOnline').textContent='● লগইন প্রয়োজন';$('mwdashStatus').textContent='এই ড্যাশবোর্ড দেখতে আগে আপনার MASTER WORLD VIP অ্যাকাউন্টে লগইন করুন।';$('mwdashBalance').textContent='—';$('mwdashEarned').textContent='—';return;}
  $('mwdashOnline').textContent='● সক্রিয় সেশন';
  $('mwdashId').textContent='Member ID: '+u.id.slice(0,8).toUpperCase();
  $('mwdashEmail').textContent='ইমেইল: '+(u.email||'—');
  $('mwdashName').textContent=u.user_metadata?.display_name||u.user_metadata?.name||'MASTER WORLD VIP Member';
  $('mwdashStatus').textContent='প্রোফাইল ও ওয়ালেট তথ্য যাচাই করা হচ্ছে…';
  try{
   const {data,error}=await cl.from('profiles').select('display_name,avatar_url,username,country').eq('id',u.id).maybeSingle();
   if(error)throw error;
   if(data){$('mwdashName').textContent=data.display_name||data.username||$('mwdashName').textContent;if(data.avatar_url){const url=new URL(data.avatar_url,location.href);if(url.protocol==='https:')$('mwdashAvatar').src=url.href;}}
   $('mwdashStatus').textContent='অ্যাকাউন্ট সংযুক্ত। ব্যক্তিগত তথ্য শুধু আপনার লগইন সেশন থেকে দেখানো হচ্ছে।';
  }catch(err){$('mwdashStatus').textContent='প্রোফাইল টেবিল/নীতি প্রস্তুত নয়: '+err.message;}
  try{
   const {data,error}=await cl.rpc('get_my_referral_wallet');if(error)throw error;
   $('mwdashBalance').textContent=money(data.available_balance);
   $('mwdashEarned').textContent=money(data.earned_total);
   $('mwdashWalletNote').textContent='Pending withdrawal: '+money(data.pending_withdrawal);
  }catch(err){$('mwdashBalance').textContent='—';$('mwdashEarned').textContent='—';$('mwdashWalletNote').textContent='Wallet migration / backend যাচাই প্রয়োজন';}
 }
 const old=window.showPage;
 if(typeof old==='function'){
  window.showPage=(id)=>{old(id);if(id==='memberDashboard')refresh();};
 }
 const oldConnect=$('connect');if(oldConnect)oldConnect.addEventListener('click',()=>setTimeout(()=>{if(user())refresh();},1000));
 const oldLogin=$('login');if(oldLogin)oldLogin.addEventListener('click',()=>setTimeout(()=>{if(user()){window.showPage?.('memberDashboard');refresh();}},1000));
 const oldLogout=$('logout');if(oldLogout)oldLogout.addEventListener('click',()=>{setTimeout(()=>{if(!user())window.showPage?.('account');},500);});
 setTimeout(()=>{if(user()){window.showPage?.('memberDashboard');refresh();}},1100);
})();