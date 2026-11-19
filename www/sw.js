const CACHE='mwvip-pwa-v7';
const CORE=['./','./index.html','./manifest.webmanifest','./icons/icon.svg'];
self.addEventListener('message',event=>{if(event.data&&event.data.type==='SKIP_WAITING')self.skipWaiting();});
self.addEventListener('install',event=>{event.waitUntil(caches.open(CACHE).then(cache=>cache.addAll(CORE)));});
self.addEventListener('activate',event=>{event.waitUntil(caches.keys().then(keys=>Promise.all(keys.filter(key=>key!==CACHE).map(key=>caches.delete(key)))).then(()=>self.clients.claim()));});
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
