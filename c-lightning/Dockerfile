FROM alpine:3.12.4 as builder

ARG CLN_VERSION="v0.10.2"

RUN apk add --update --no-cache \
    ca-certificates \
    alpine-sdk \
    autoconf \
    automake \
    git \
    libtool \
    gmp-dev \
    sqlite-dev \
    python3-dev \
    py3-mako \
    net-tools \
    zlib-dev \
    libsodium \
    gettext \
    postgresql-dev \
    libffi-dev \
    py3-cryptography \
    py3-pip \
    cargo

ARG DEVELOPER=1
ENV PYTHON_VERSION=3

RUN git clone --single-branch --branch ${CLN_VERSION} --recursive https://github.com/ElementsProject/lightning.git \
 && cd lightning \
 && pip3 install --upgrade pip \
 && pip3 install -r requirements.txt --use-feature=in-tree-build \
 && ./configure --prefix=/tmp/lightning_install --enable-developer \
 && make -j3 DEVELOPER=${DEVELOPER} \
 && make install

FROM alpine:3.12.4 as clboss

ENV CLBOSS_VERSION="0.11B"

# Let's check out version 0.11B: commit 1e3c9085c383dc0bf25070b2c6a867937d801970
RUN apk add --update --no-cache git autoconf alpine-sdk automake libtool pkgconfig sqlite-dev libev-dev gnutls-dev bind-tools autoconf-archive sqlite pkgconf libev curl curl-dev \
 && git clone --single-branch --branch ${CLBOSS_VERSION} https://github.com/ZmnSCPxj/clboss.git \
 && cd clboss \
 && autoreconf -i \
 && ./configure && make && make install

# Let's create the actual image that will be run

FROM cyphernode/alpine-glibc-base:v3.12.4_2.31-0

RUN apk add --update --no-cache \
    gmp-dev \
    sqlite-dev \
    postgresql-dev \
    inotify-tools \
    socat \
    bash \
    zlib-dev \
    py3-pip \
    python3-dev \
    g++ \
    linux-headers \
    su-exec \
    libev \
    curl \
    bind-tools \
    postgresql

RUN pip install pyln-client pyln-testing

ENV LIGHTNINGD_DATA=/.lightning
ENV LIGHTNINGD_RPC_PORT=9835

VOLUME ["/.bitcoin", "/.lightning"]

COPY --from=builder /tmp/lightning_install/ /usr/local/
COPY --from=clboss /usr/local/bin/clboss /usr/local/bin
COPY --from=cyphernode/bitcoin:v22.0 /usr/bin/bitcoin-cli /usr/bin
COPY bitcoin.conf /.bitcoin/bitcoin.conf

EXPOSE 9735

ENTRYPOINT ["su-exec"]
# docker run -d --rm --name cln -p 9735:9735 -v /home/pi/lndata:/.lightning clnimg `id -u lnuser`:`id -g lnuser` lightningd
