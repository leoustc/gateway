#!/bin/bash
set -e

# Create oauth2-proxy config
cat <<EOF > /oauth2.cfg
provider = "${OAUTH2_PROVIDER}"
client_id = "${OAUTH2_CLIENT_ID}"
client_secret = "${OAUTH2_CLIENT_SECRET}"
email_domains = [ $(echo "$ALLOWED_DOMAINS" | sed 's/,/","/g' | sed 's/^/"/;s/$/"/') ]
authenticated_emails_file = "/allowed_emails.txt"
cookie_secret = "${COOKIE_SECRET}"
upstreams = [ "file:///dev/null" ]
http_address = "127.0.0.1:4180"
redirect_url = "${PUBLIC_URL}/oauth2/callback"
skip_provider_button = true
set_xauthrequest = true
cookie_secure = true
cookie_samesite = "lax"
EOF

echo "${ALLOWED_EMAILS}" | tr ',' '\n' > /allowed_emails.txt

# Create nginx config
envsubst '${UPSTREAM_URL} ${NGINX_CONFIG_EXTRAS}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Run both services
oauth2-proxy --config /oauth2.cfg &
nginx -g "daemon off;" &

sleep 5
# Log environment info for debug
echo "========================="
echo "[+] Loaded environment:"
env | grep -E 'OATUH2_CLIENT|COOKIE_SECRET|UPSTREAM_URL|NGINX_CONFIG_EXTRAS|PUBLIC_URL'
echo "[+] redirect_url: ${PUBLIC_URL}/oauth2/callback"
echo "[+] allowed domains: ${ALLOWED_DOMAINS}"
echo "[+] allowed emails: ${ALLOWED_EMAILS}"
echo "========================="
wait