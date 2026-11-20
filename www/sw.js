const CACHE='mwvip-pwa-v18';
const CORE=['./','./index.html','./manifest.webmanifest','./icons/icon.svg'];
self.addEventListener('message',event=>{if(event.data&&event.data.type==='SKIP_WAITING')self.skipWaiting();});
self.addEventListener('install',event=>{event.waitUntil(caches.open(CACHE).then(cache=>cache.addAll(CORE)));});
self.addEventListener('activate',event=>{event.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(key=>key!==CACHE).map(key=>caches.delete(key)))).then(()=>self.clients.claim()));});
self.addEventListener('push',event=>{
 let payload={title:'MASTER WORLD VIP',body:'আপনার নতুন নোটিফিকেশন এসেছে।',url:'./'};
 try{if(event.data){const parsed=event.data.json();payload={...payload,...parsed};}}catch(_error){try{payload.body=event.data.text();}catch(__error){}}
 event.waitUntil(self.registration.showNotification(payload.title||'MASTER WORLD VIP',{
  body:payload.body||'নতুন বার্তা এসেছে।',icon:'./icons/icon-192.svg',badge:'./icons/icon-192.svg',
  tag:payload.tag||'mwvip-message',data:{url:payload.url||'./'}
 }));
});
self.addEventListener('notificationclick',event=>{
 event.notification.close();
 const target=new URL(event.notification.data?.url||'./',self.location.origin).href;
 event.waitUntil(clients.matchAll({type:'window',includeUncontrolled:true}).then(list=>{
  for(const client of list){if(client.url.startsWith(self.location.origin)&&'focus' in client){client.navigate(target);return client.focus();}}
  return clients.openWindow?clients.openWindow(target):undefined;
 }));
});
self.addEventListener('fetch',event=>{
 const req=event.request;
 if(req.method!=='GET') return;
 const url=new URL(req.url);
 if(url.origin!==self.location.origin) return;
 event.respondWith(caches.match(req).then(cached=>cached||fetch(req).then(response=>{
  if(response.ok && (req.mode==='navigate'||url.pathname.includes('/icons/')||url.pathname.endsWith('.webmanifest'))){const copy=response.clone();caches.open(CACHE).then(cache=>cache.put(req,copy));}
  return response;
 }).catch(()=>caches.match('./index.html'))));
});
