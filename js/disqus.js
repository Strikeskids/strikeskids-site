document.addEventListener('DOMContentLoaded', function () {
  var el = document.getElementById('disqus_thread')
  if (!el) return

  window.disqus_config = {
    url: el.dataset.url,
    identifier: el.dataset.identifier,
  }

  var script = document.createElement('script')
  script.src = '//strikeskids.disqus.com/embed.js';

  script.setAttribute('data-timestamp', +new Date());
  (document.head || document.body).appendChild(script);
})
