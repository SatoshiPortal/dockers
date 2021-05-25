FROM alpine:3.12.4 as builder

ARG CLN_VERSION="v0.10.0"

ENV LIGHTNINGD_VERSION=master

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

RUN git clone https://github.com/ElementsProject/lightning.git \
 && cd lightning && git checkout ${CLN_VERSION} \
 && git submodule update --init --recursive \
 && pip3 install -r requirements.txt \
 && ./configure --prefix=/tmp/lightning_install --enable-developer \
 && make -j3 DEVELOPER=${DEVELOPER} \
 && make install

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
    su-exec

ENV LIGHTNINGD_DATA=/.lightning
ENV LIGHTNINGD_RPC_PORT=9835

VOLUME ["/.bitcoin", "/.lightning"]

COPY --from=builder /tmp/lightning_install/ /usr/local/
COPY --from=cyphernode/bitcoin:v0.21.1 /usr/bin/bitcoin-cli /usr/bin
COPY bitcoin.conf /.bitcoin/bitcoin.conf

EXPOSE 9735

ENTRYPOINT ["su-exec"]
# docker run -d --rm --name cln -p 9735:9735 -v /home/pi/lndata:/.lightning clnimg `id -u lnuser`:`id -g lnuser` lightningd
