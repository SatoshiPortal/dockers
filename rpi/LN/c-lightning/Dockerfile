# Ref.: https://github.com/cdecker/dockerfiles/blob/master/lightning/node/Dockerfile

FROM resin/raspberrypi3-debian:stretch
ENV LIGHTNINGD_VERSION=master

ARG USER_ID
ARG GROUP_ID
ENV HOME /lnuser
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

RUN groupadd -g ${GROUP_ID} lnuser \
    && useradd -u ${USER_ID} -g lnuser -s /bin/bash -m -d ${HOME} lnuser

RUN apt-get update -qq \
 && apt-get install -qq -y --no-install-recommends --allow-unauthenticated \
    autoconf \
    automake \
    bitcoind \
    build-essential \
    ca-certificates \
    curl \
    libbase58-dev \
    libgmp-dev \
    libprotobuf-c-dev \
    libsodium-dev \
    libsqlite3-dev \
    libtool \
    make \
    net-tools \
    python \
    python3 \
    valgrind \
    git \
    gosu \
    jq \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* \
 && mkdir $HOME/.bitcoin $HOME/.lightning

RUN git clone https://github.com/ElementsProject/lightning.git /opt/lightningd \
 && cd /opt/lightningd \
 && git checkout $LIGHTNINGD_VERSION \
 && make \
 && cp lightningd/lightning* cli/lightning-cli /usr/bin/ \
 && rm -rf /opt/lightningd

VOLUME ["${HOME}/.bitcoin", "${HOME}/.lightning"]
EXPOSE 9735
WORKDIR ${HOME}

ENTRYPOINT ["gosu"]
CMD ["lnuser","lightningd"]
