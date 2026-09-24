const CACHE='pet-checkin-v0.5.10.7';
const ASSETS=['./index.html','./manifest.webmanifest'];

self.addEventListener('install',e=>{
  self.skipWaiting();
  e.waitUntil(caches.open(CACHE).then(c=>c.addAll(ASSETS)));
});

self.addEventListener('activate',e=>e.waitUntil(
  caches.keys()
    .then(keys=>Promise.all(keys.filter(k=>k!==CACHE).map(k=>caches.delete(k))))
    .then(()=>self.clients.claim())
));

self.addEventListener('fetch',e=>{
  const url=new URL(e.request.url);

  // Cloud sync uses cross-origin POST requests. Let the browser send those
  // directly instead of routing them through the Service Worker.
  if(url.origin!==self.location.origin || e.request.method!=='GET') return;

  if(e.request.mode==='navigate'){
    e.respondWith(
      fetch(e.request)
        .then(r=>{
          const copy=r.clone();
          caches.open(CACHE).then(c=>c.put('./index.html',copy)).catch(()=>{});
          return r;
        })
        .catch(async()=>{
          const cached=await caches.match('./index.html');
          return cached || Response.error();
        })
    );
    return;
  }

  e.respondWith(
    caches.match(e.request).then(cached=>{
      if(cached) return cached;
      return fetch(e.request);
    })
  );
});
