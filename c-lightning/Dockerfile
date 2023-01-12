# ----------------------------------------------------------------------
# Build layer
# ----------------------------------------------------------------------

FROM debian:bullseye-slim as builder

ENV LIGHTNINGD_VERSION=v22.11.1

RUN apt update && apt install -y \
    autoconf \
    automake \
    build-essential \
    ca-certificates \
    curl \
    dirmngr \
    gettext \
    git \
    gnupg \
    libpq-dev \
    libtool \
    libffi-dev \
    python3 \
    python3-dev \
    python3-mako \
    python3-pip \
    python3-venv \
    python3-setuptools \
    wget \
    libgmp3-dev \
    libsqlite3-dev \
    cargo \
    libssl-dev \
    pkg-config

RUN git clone --single-branch --branch ${LIGHTNINGD_VERSION} --recursive https://github.com/ElementsProject/lightning.git

WORKDIR /lightning

RUN pip3 install -U pip \
 && pip3 install -U wheel \
 && curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/install-poetry.py | python3 - \
 && /root/.local/bin/poetry export --without-hashes -o requirements.txt \
 && pip3 install -r requirements.txt

RUN ./configure --prefix=/tmp/lightning_install --enable-static && make -j3 DEVELOPER=${DEVELOPER} && make install

RUN mkdir tmp-pyln \
 && cp -r /usr/local/lib/python3.9/dist-packages/pyln* tmp-pyln/


# ----------------------------------------------------------------------
# CLBOSS
# ----------------------------------------------------------------------

FROM debian:bullseye-slim as clboss

# Let's get master as of Jul 14, commit 9962497affbc7917de3757a20f3bc3345a3eb26b
RUN apt update && apt install -y \
    build-essential \
    pkg-config \
    libev-dev \
    libcurl4-gnutls-dev \
    libsqlite3-dev \
    dnsutils \
    git \
    automake \
    autoconf-archive \
    libtool \
 && git clone https://github.com/ZmnSCPxj/clboss.git \
 && cd clboss \
 && git checkout 9962497affbc7917de3757a20f3bc3345a3eb26b \
 && autoreconf -i \
 && ./configure && make && make install


# ----------------------------------------------------------------------
# FINAL layer
# ----------------------------------------------------------------------

FROM debian:bullseye-slim as final

ENV LIGHTNINGD_DATA=/.lightning
ENV LIGHTNINGD_RPC_PORT=9835
ENV LIGHTNINGD_PORT=9735
ENV LIGHTNINGD_NETWORK=bitcoin

RUN apt-get update && apt-get install -y --no-install-recommends \
    socat \
    inotify-tools \
    python3 \
    python3-pip \
    libpq5 \
    cargo \
    autoconf automake build-essential libffi-dev libtool pkg-config python3-dev \
    openssl libssl-dev libev-dev dnsutils \
&& rm -rf /var/lib/apt/lists/* \
&& mkdir $LIGHTNINGD_DATA \
&& touch $LIGHTNINGD_DATA/config

VOLUME ["/.bitcoin", "/.lightning"]

COPY --from=builder /lightning/tmp-pyln/ /usr/local/lib/python3.9/dist-packages/
COPY --from=builder /tmp/lightning_install/ /usr/local/
COPY --from=builder /lightning/tools/docker-entrypoint.sh entrypoint.sh
COPY --from=clboss /usr/local/bin/clboss /usr/local/bin
COPY --from=cyphernode/bitcoin:v22.0-mosquitto-debian /usr/bin/bitcoin-cli /usr/bin
COPY bitcoin.conf /.bitcoin/bitcoin.conf

EXPOSE 9735 9835
