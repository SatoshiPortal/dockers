FROM node:16.8-bullseye-slim as builder

# Install build dependencies for third-party packages (c-lightning/bitcoind)
RUN apt-get update && apt-get install -y --no-install-recommends git ca-certificates dirmngr wget

# npm doesn't normally like running as root, allow it since we're in docker
RUN npm config set unsafe-perm true

# Install Spark
WORKDIR /opt
RUN git clone https://github.com/shesek/spark-wallet.git spark \
 && cd spark \
 && git checkout 112fd9b

COPY patch.diff /opt/spark/
RUN cd spark \
 && git apply patch.diff

WORKDIR /opt/spark/client
RUN npm install

WORKDIR /opt/spark
RUN npm install

# Build production NPM package
RUN npm run dist:npm \
 && npm prune --production \
 && find . -mindepth 1 -maxdepth 1 \
           ! -name '*.json' ! -name dist ! -name LICENSE ! -name node_modules ! -name scripts \
           -exec rm -r "{}" \;

# Prepare final image

FROM node:16.8-bullseye-slim

WORKDIR /opt/spark

RUN apt-get update && apt-get install -y --no-install-recommends xz-utils inotify-tools netcat-openbsd tini

COPY --from=builder /opt/spark /opt/spark

ENV CONFIG=/data/spark/config TLS_PATH=/data/spark/tls TOR_PATH=/data/spark/tor COOKIE_FILE=/data/spark/cookie HOST=0.0.0.0

# link the granax (Tor Control client) node_modules installation directory
# inside /data/spark/tor/, to persist the Tor Bundle download in the user-mounted volume
RUN ln -s $TOR_PATH/tor-installation/node_modules dist/transport/granax-dep/node_modules

VOLUME /data
ENTRYPOINT [ "tini", "-g", "--", "scripts/docker-entrypoint.sh" ]

EXPOSE 9735 9737
