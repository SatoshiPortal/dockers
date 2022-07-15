FROM node:16.8-bullseye-slim as builder

# Default building version v0.3.1
ENV SPARKWALLET_VERSION=v0.3.1

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    ca-certificates

# npm doesn't normally like running as root, allow it since we're in docker
RUN npm config set unsafe-perm true

RUN git clone --single-branch --branch ${SPARKWALLET_VERSION} https://github.com/shesek/spark-wallet.git /opt/spark \
 && cd /opt/spark/client \
 && npm install \
 && cd .. \
 && npm install \
 && npm run dist:npm \
 && npm prune --production \
 && find . -mindepth 1 -maxdepth 1 \
    ! -name '*.json' ! -name dist ! -name LICENSE ! -name node_modules ! -name scripts \
    -exec rm -r "{}" \;

FROM node:16.8-alpine3.11

WORKDIR /opt/spark

RUN apk add --update --no-cache bash xz inotify-tools tini netcat-openbsd \
 && ln -s /opt/spark/dist/cli.js /usr/bin/spark-wallet \
 && mkdir /data \
 && ln -s /data/lightning $HOME/.lightning

COPY --from=builder /opt/spark /opt/spark

ENV CONFIG=/data/spark/config TLS_PATH=/data/spark/tls TOR_PATH=/data/spark/tor COOKIE_FILE=/data/spark/cookie HOST=0.0.0.0

VOLUME /data
ENTRYPOINT [ "tini", "-g", "--", "scripts/docker-entrypoint.sh" ]

EXPOSE 9737
