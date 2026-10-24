// Offline cache: network-first (so updates show up), falls back to cache when offline.
const CACHE = 'sd1-tracker-v1792850963';
const FILES = ['./', 'index.html', 'manifest.webmanifest', 'icon.png'];
self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(FILES)));
  self.skipWaiting();
});
self.addEventListener('activate', e => e.waitUntil(self.clients.claim()));
self.addEventListener('fetch', e => {
  if (e.request.method !== 'GET') return;
  const timeout = new Promise((_, rej) => setTimeout(rej, 3000));
  e.respondWith(
    Promise.race([fetch(e.request), timeout])
      .then(r => { const copy = r.clone(); caches.open(CACHE).then(c => c.put(e.request, copy)); return r; })
      .catch(() => caches.match(e.request, { ignoreSearch: true }).then(r => r || caches.match('index.html')))
  );
});
