FROM alpine:3.7 as builder

# Let's create the builder

RUN apk add --update --no-cache \
     ca-certificates \
     autoconf \
     automake \
     build-base \
     libressl \
     libtool \
     gmp-dev \
     python \
     python-dev \
     python3 \
     sqlite-dev \
     wget \
     git \
     file \
     gnupg \
     swig \
     zlib-dev

WORKDIR /opt

ARG BITCOIN_VERSION=0.16.2
ENV BITCOIN_TARBALL bitcoin-$BITCOIN_VERSION-x86_64-linux-gnu.tar.gz
ENV BITCOIN_URL https://bitcoincore.org/bin/bitcoin-core-$BITCOIN_VERSION/$BITCOIN_TARBALL
ENV BITCOIN_ASC_URL https://bitcoincore.org/bin/bitcoin-core-$BITCOIN_VERSION/SHA256SUMS.asc
ENV BITCOIN_PGP_KEY 01EA5486DE18A882D4C2684590C8019E36C2E964

RUN mkdir /opt/bitcoin && cd /opt/bitcoin \
 && wget -qO $BITCOIN_TARBALL "$BITCOIN_URL" \
 && gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "$BITCOIN_PGP_KEY" \
 && wget -qO bitcoin.asc "$BITCOIN_ASC_URL" \
 && gpg --verify bitcoin.asc \
 && grep $BITCOIN_TARBALL bitcoin.asc | tee SHA256SUMS.asc \
 && sha256sum -c SHA256SUMS.asc \
 && BD=bitcoin-$BITCOIN_VERSION/bin \
 && tar -xzvf $BITCOIN_TARBALL $BD/bitcoin-cli --strip-components=1 \
 && rm $BITCOIN_TARBALL

ENV LIGHTNINGD_VERSION=master

WORKDIR /opt/lightningd

ARG DEVELOPER=0
RUN git clone https://github.com/ElementsProject/lightning.git /opt/lightningd \
 && ./configure && make -j3 DEVELOPER=${DEVELOPER} && cp lightningd/lightning* cli/lightning-cli /usr/bin/

# Let's create the actual image that will be run

FROM alpine:3.7

# Taking care of glibc shit (glibc not natively supported by Alpine but Bitcoin Core uses it)

ENV GLIBC_VERSION 2.27-r0
ENV GLIBC_SHA256 938bceae3b83c53e7fa9cc4135ce45e04aae99256c5e74cf186c794b97473bc7
ENV GLIBCBIN_SHA256 3a87874e57b9d92e223f3e90356aaea994af67fb76b71bb72abfb809e948d0d6
# Download and install glibc (https://github.com/jeanblanchard/docker-alpine-glibc/blob/master/Dockerfile)
RUN wget -O /etc/apk/keys/sgerrand.rsa.pub https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/sgerrand.rsa.pub \
 && wget -O glibc.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" \
 && echo "$GLIBC_SHA256  glibc.apk" | sha256sum -c - \
 && wget -O glibc-bin.apk "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" \
 && echo "$GLIBCBIN_SHA256  glibc-bin.apk" | sha256sum -c - \
 && apk add --update --no-cache glibc-bin.apk glibc.apk \
 && /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib \
 && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf \
 && rm -rf glibc.apk glibc-bin.apk

 RUN apk add --update --no-cache \
    gmp-dev \
    sqlite-dev \
    inotify-tools \
    socat \
    bash \
    zlib-dev \
    su-exec

ARG USER_ID
ARG GROUP_ID
ENV USERNAME lnuser
ENV HOME /${USERNAME}
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}
ENV LIGHTNINGD_DATA=${HOME}/.lightning
ENV LIGHTNINGD_RPC_PORT=9735

RUN addgroup -g ${GROUP_ID} ${USERNAME} \
 && adduser -u ${USER_ID} -G ${USERNAME} -D -s /bin/sh -h ${HOME} ${USERNAME}

VOLUME ["${HOME}/.bitcoin", "${HOME}/.lightning"]

COPY --from=builder /opt/lightningd/cli/lightning-cli /usr/bin
COPY --from=builder /opt/lightningd/lightningd/lightning* /usr/bin/
COPY --from=builder /opt/bitcoin/bin /usr/bin
COPY bitcoin.conf ${HOME}/.bitcoin/bitcoin.conf
RUN chown -R ${USERNAME}:${USERNAME} ${HOME}
WORKDIR ${HOME}

EXPOSE 9735

ENTRYPOINT ["su-exec"]
CMD ["lnuser","lightningd"]
