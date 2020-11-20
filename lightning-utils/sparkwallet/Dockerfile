FROM node:14.10.1-buster-slim as builder

RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates git python3 build-essential

# npm doesn't normally like running as root, allow it since we're in docker
RUN npm config set unsafe-perm true

# Install Spark
WORKDIR /opt
RUN git clone -b v0.2.17 https://github.com/shesek/spark-wallet.git spark \
 && cd spark/client \
 && npm install

WORKDIR /opt/spark
RUN npm install

# Build production NPM package
RUN npm run dist:npm \
 && npm prune --production \
 && find . -mindepth 1 -maxdepth 1 \
           ! -name '*.json' ! -name dist ! -name LICENSE ! -name node_modules ! -name scripts \
           -exec rm -r "{}" \;


FROM node:14.10.1-alpine3.11

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

