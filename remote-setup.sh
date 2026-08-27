#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive
if ! command -v nginx >/dev/null 2>&1; then
  apt-get update -qq
  apt-get install -y -qq nginx
fi

cat > /etc/nginx/sites-available/embedded-ai-kit <<'NGINX'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    server_name _;
    root /var/www/embedded-ai-kit;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }

    location /downloads/ {
        autoindex off;
        types { }
        default_type application/octet-stream;
        add_header Content-Disposition 'attachment';
        add_header X-Content-Type-Options nosniff;
    }

    location ~* \.(css|js|png|jpg|svg|ico|woff2?|json)$ {
        expires 1h;
        add_header Cache-Control "public";
    }
}
NGINX

ln -sf /etc/nginx/sites-available/embedded-ai-kit /etc/nginx/sites-enabled/embedded-ai-kit
rm -f /etc/nginx/sites-enabled/default
nginx -t
systemctl daemon-reload
systemctl enable nginx
systemctl enable embedded-ai-kit-web.service
systemctl restart nginx
systemctl start embedded-ai-kit-web.service
echo "enabled nginx=$(systemctl is-enabled nginx)"
echo "enabled kit=$(systemctl is-enabled embedded-ai-kit-web.service)"
echo "active nginx=$(systemctl is-active nginx)"
echo "active kit=$(systemctl is-active embedded-ai-kit-web.service)"
ls -la /var/www/embedded-ai-kit/
curl -sI http://127.0.0.1/ | head -6
