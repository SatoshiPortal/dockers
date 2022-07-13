FROM debian:bullseye-slim as builder

ENV LIGHTNINGD_VERSION=v0.11.2

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
# && pip3 install -U coincurve \
# && pip3 install -U mrkd \
 && /root/.local/bin/poetry config virtualenvs.create false \
 && /root/.local/bin/poetry install

RUN ./configure --prefix=/tmp/lightning_install --enable-static && make -j3 DEVELOPER=${DEVELOPER} && make install


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
&& rm -rf /var/lib/apt/lists/* \
&& mkdir $LIGHTNINGD_DATA \
&& touch $LIGHTNINGD_DATA/config

VOLUME [ "/.lightning" ]

COPY --from=builder /tmp/lightning_install/ /usr/local/
COPY --from=builder /lightning/tools/docker-entrypoint.sh entrypoint.sh

EXPOSE 9735 9835
