# Deploy Embedded AI Development Kit landing page to 39.97.234.200
$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$Remote = "root@39.97.234.200"
$WebRoot = "/var/www/embedded-ai-kit"

Write-Host "Uploading web files to ${Remote}:${WebRoot} ..."
ssh $Remote "mkdir -p $WebRoot/downloads"
scp "$Root\index.html" "$Root\styles.css" "$Root\app.js" "${Remote}:${WebRoot}/"
scp "$Root\downloads\manifest.json" "$Root\downloads\README.md" "${Remote}:${WebRoot}/downloads/"
scp "$Root\embedded-ai-kit-web.service" "${Remote}:/etc/systemd/system/embedded-ai-kit-web.service"

# Upload any release zips if present
Get-ChildItem -Path (Join-Path $Root "downloads") -Filter "*.zip" -ErrorAction SilentlyContinue |
  ForEach-Object { scp $_.FullName "${Remote}:${WebRoot}/downloads/" }

Write-Host "Configuring nginx + systemd autostart ..."
scp "$Root\remote-setup.sh" "${Remote}:/tmp/embedded-ai-kit-setup.sh"
ssh $Remote "sed -i 's/\r$//' /tmp/embedded-ai-kit-setup.sh /etc/systemd/system/embedded-ai-kit-web.service; bash /tmp/embedded-ai-kit-setup.sh"

Write-Host "Done. Open http://39.97.234.200/"
