async function loadDownloads() {
  const rows = document.querySelectorAll('.dl-card[data-product]');
  let manifest = null;
  try {
    const res = await fetch('downloads/manifest.json', { cache: 'no-store' });
    if (res.ok) manifest = await res.json();
  } catch (e) {
    return;
  }
  if (!manifest || !Array.isArray(manifest.packages)) return;

  const byId = {};
  for (const pkg of manifest.packages) {
    if (pkg && pkg.id) byId[pkg.id] = pkg;
  }

  rows.forEach((row) => {
    const id = row.getAttribute('data-product');
    const pkg = byId[id];
    const statusEl = row.querySelector('[data-status]');
    const linkEl = row.querySelector('[data-download]');
    if (!pkg || !pkg.file) return;

    const href = /^https?:\/\//i.test(pkg.file)
      ? pkg.file
      : 'downloads/' + encodeURIComponent(pkg.file);
    const version = pkg.version ? (' v' + pkg.version) : '';
    statusEl.textContent = '测试版' + version;
    statusEl.classList.remove('soon');
    statusEl.classList.add('ready');
    linkEl.href = href;
    linkEl.hidden = false;
    if (pkg.filename && !/^https?:\/\//i.test(pkg.file)) {
      linkEl.setAttribute('download', pkg.filename);
    }
  });
}

loadDownloads();
