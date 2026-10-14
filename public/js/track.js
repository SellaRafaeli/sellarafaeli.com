// First-party analytics: records page loads and clicks into mongo via POST /track.
(function () {
  if (window.__srTrack) return;
  try { if (localStorage.getItem('sr_ignore')) return; } catch (e) {} // set from /admin ("don't count my visits")
  window.__srTrack = true;

  function id() { return Math.random().toString(36).slice(2, 10) + Date.now().toString(36); }
  function stored(store, key) {
    try {
      var v = store.getItem(key);
      if (!v) { v = id(); store.setItem(key, v); }
      return v;
    } catch (e) { return null; }
  }

  var vid = stored(localStorage, 'sr_vid');   // visitor (persists across visits)
  var sid = stored(sessionStorage, 'sr_sid'); // session (this tab)

  function send(data) {
    data.vid = vid;
    data.sid = sid;
    data.path = location.pathname;
    data.query = location.search;
    var body = JSON.stringify(data);
    try {
      if (navigator.sendBeacon && navigator.sendBeacon('/track', new Blob([body], { type: 'text/plain' }))) return;
    } catch (e) {}
    try { fetch('/track', { method: 'POST', body: body, keepalive: true, headers: { 'Content-Type': 'text/plain' } }); } catch (e) {}
  }

  send({
    type: 'pageview',
    title: document.title,
    referrer: document.referrer,
    screen: screen.width + 'x' + screen.height,
    lang: navigator.language,
    tz: (Intl.DateTimeFormat().resolvedOptions() || {}).timeZone
  });

  document.addEventListener('click', function (e) {
    var el = e.target && e.target.closest && e.target.closest('a, button, [role=button], input[type=submit], input[type=button], summary, [data-track]');
    if (!el) return;
    var text = el.getAttribute('data-track') || el.getAttribute('aria-label') || el.innerText || el.value || el.title || '';
    send({
      type: 'click',
      tag: el.tagName.toLowerCase(),
      text: text.replace(/\s+/g, ' ').trim().slice(0, 100),
      href: el.href || el.getAttribute('href') || null,
      el_id: el.id || null,
      el_class: (typeof el.className === 'string' ? el.className : '') || null
    });
  }, true);
})();
