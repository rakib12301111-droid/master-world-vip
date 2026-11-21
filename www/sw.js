const CACHE = 'mwvip-pwa-v24';
const CACHE_PREFIX = 'mwvip-pwa-';
const CORE = [
  './',
  './index.html',
  './manifest.webmanifest',
  './icons/icon.svg',
  './icons/icon-192.svg',
  './icons/icon-512.svg',
  './assets/mwvip-global-banner.svg'
];

self.addEventListener('message', (event) => {
  if (event.data?.type === 'SKIP_WAITING') self.skipWaiting();
});

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE).then((cache) => cache.addAll(CORE))
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys()
      .then((keys) => Promise.all(
        keys
          .filter((key) => key.startsWith(CACHE_PREFIX) && key !== CACHE)
          .map((key) => caches.delete(key))
      ))
      .then(() => self.clients.claim())
  );
});

self.addEventListener('push', (event) => {
  let payload = {
    title: 'MASTER WORLD VIP',
    body: 'আপনার নতুন নোটিফিকেশন এসেছে।',
    url: './'
  };

  try {
    if (event.data) payload = { ...payload, ...event.data.json() };
  } catch (_error) {
    try {
      if (event.data) payload.body = event.data.text();
    } catch (_ignored) {}
  }

  event.waitUntil(
    self.registration.showNotification(payload.title || 'MASTER WORLD VIP', {
      body: payload.body || 'নতুন বার্তা এসেছে।',
      icon: './icons/icon-192.svg',
      badge: './icons/icon-192.svg',
      tag: payload.tag || 'mwvip-message',
      data: { url: payload.url || './' }
    })
  );
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const target = new URL(
    event.notification.data?.url || './',
    self.location.origin
  ).href;

  event.waitUntil(
    self.clients.matchAll({ type: 'window', includeUncontrolled: true })
      .then((list) => {
        for (const client of list) {
          if (client.url.startsWith(self.location.origin) && 'focus' in client) {
            client.navigate(target);
            return client.focus();
          }
        }
        return self.clients.openWindow ? self.clients.openWindow(target) : undefined;
      })
  );
});

self.addEventListener('fetch', (event) => {
  const request = event.request;
  if (request.method !== 'GET') return;

  const url = new URL(request.url);
  if (url.origin !== self.location.origin) return;

  if (request.mode === 'navigate') {
    event.respondWith(
      fetch(request)
        .then((response) => {
          if (response.ok) {
            const copy = response.clone();
            caches.open(CACHE).then((cache) => cache.put(request, copy));
          }
          return response;
        })
        .catch(async () => (await caches.match(request)) || caches.match('./index.html'))
    );
    return;
  }

  event.respondWith(
    caches.match(request).then((cached) => {
      if (cached) return cached;
      return fetch(request).then((response) => {
        if (response.ok && (
          url.pathname.includes('/icons/') ||
          url.pathname.includes('/assets/') ||
          url.pathname.endsWith('.webmanifest')
        )) {
          const copy = response.clone();
          caches.open(CACHE).then((cache) => cache.put(request, copy));
        }
        return response;
      });
    })
  );
});
