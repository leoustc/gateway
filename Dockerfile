FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt update && apt install -y \
    nginx \
    curl \
    wget \
    ca-certificates \
    gettext-base \
    jq \
    && useradd -m oauth2proxy \
    && wget -qO- https://github.com/oauth2-proxy/oauth2-proxy/releases/download/v7.5.1/oauth2-proxy-v7.5.1.linux-amd64.tar.gz \
       | tar xz --strip-components=1 -C /usr/local/bin oauth2-proxy-v7.5.1.linux-amd64/oauth2-proxy

COPY src/entry.sh /entry.sh
COPY src/nginx.conf.template /etc/nginx/nginx.conf.template

RUN chmod +x /entry.sh

ENTRYPOINT ["/entry.sh"]