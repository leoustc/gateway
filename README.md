# 🔐 OAuth2-Enabled Nginx Reverse Proxy

A single-container NGINX + oauth2-proxy reverse proxy gateway for securing upstream apps with **GitHub OAuth2 login**, cookie-based sessions, API key access, and email/domain restrictions.

---

## 📦 Docker Image

```bash
docker pull leoustc/nginx:oauth2
```

---

## 🚀 Quick Start

### 🔧 1. `docker-compose.yml`

```yaml
version: "3.9"

services:
  auth-gateway:
    build: .
    image: leoustc/nginx:oauth2
    ports:
      - "3000:80"
    env_file:
      - .env
```

### 🔐 2. `.env`

```env
# Public address used for OAuth redirect
PUBLIC_URL=https://your.domain.com

# OAuth2 provider credentials
OAUTH2_PROVIDER=github
OAUTH2_CLIENT_ID=Iv1.6a7bxxxxxxxx3fa0
OAUTH2_CLIENT_SECRET=7c91xxxxxxxxe3bba240af1d4cc4f22c84937ff92

# Secure random 32-byte cookie secret
COOKIE_SECRET=Z1dXu72lqRxxxxxxxxHCB9Qv5Xe6jfVd

# Whitelisted login identities
ALLOWED_EMAILS=someone@gmail.com,user@examples.com,user2@goo.com
ALLOWED_DOMAINS=example.com,leoustc.com

# Where to send authenticated traffic
UPSTREAM_URL=http://192.168.10.11:3001

# Optional: extra directives to include in nginx.conf
NGINX_CONFIG_EXTRAS=
```

---

## 🔑 Auth Behavior

- `/` → Requires GitHub login → Reverse proxy to `UPSTREAM_URL`
- `/oauth2/*` → Internal routes for auth/callback/session check
- `/logout` → Clears session cookie and redirects to `/`
- `/github` → Admin redirect to GitHub App installation (if `GITHUB_APP_SLUG` is defined)
- Optional API access via `Authorization: Bearer <API_KEY>`

---

## 🧾 GitHub OAuth Setup

1. Visit https://github.com/settings/developers
2. Create an **OAuth App**
3. Set the **Authorization callback URL** to:

```
https://your.domain.com/oauth2/callback
```

4. Use your Client ID and Secret in `.env`

---

## 🧠 Notes

- `COOKIE_SECRET` must be exactly 16, 24, or 32 ASCII characters
- `PUBLIC_URL` must match your deployed domain for OAuth to succeed
- Email/domain restrictions can be combined using:
  - `ALLOWED_EMAILS` (comma-separated)
  - `ALLOWED_DOMAINS` (comma-separated)
- Add custom nginx directives via `NGINX_CONFIG_EXTRAS`

---

## ✅ Testing

```bash
docker compose up --build
```

Then visit:

- http://localhost:3000 → login via GitHub
- http://localhost:3000/logout → logout and clear session

---

## 🧰 Built With

- [NGINX](https://nginx.org/)
- [oauth2-proxy](https://github.com/oauth2-proxy/oauth2-proxy)
- [Docker](https://www.docker.com/)
- [GitHub OAuth](https://docs.github.com/en/apps/oauth-apps)

---

## 🛡 License

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at:
   http://www.apache.org/licenses/LICENSE-2.0

---

## 🙋‍♂️ Author

[leoustc](https://github.com/leoustc)