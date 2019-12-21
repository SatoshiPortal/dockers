FROM cyphernode/alpine-glibc-base:3.11.0_2.29-0

ARG CORE_VERSION="0.19.0.1"

# x86_64, arm or aarch64
ARG ARCH
ENV URL https://bitcoincore.org/bin/bitcoin-core-${CORE_VERSION}

RUN apk add --update --no-cache \
    curl \
    su-exec \
    gnupg

VOLUME ["/.bitcoin"]

WORKDIR /usr/bin

RUN wget ${URL}/SHA256SUMS.asc \
 && gpg --recv-keys "01EA5486DE18A882D4C2684590C8019E36C2E964" \
 && gpg --verify SHA256SUMS.asc \
 && GNU=$([ "${ARCH}" = "arm" ] && echo eabihf || true) \
 && TARBALL=bitcoin-${CORE_VERSION}-${ARCH}-linux-gnu${GNU}.tar.gz \
 && wget ${URL}/$TARBALL \
 && grep $TARBALL SHA256SUMS.asc | sha256sum -c - \
 && tar -xzC . -f $TARBALL bitcoin-${CORE_VERSION}/bin/bitcoind bitcoin-${CORE_VERSION}/bin/bitcoin-cli --strip-components=2 \
 && rm -rf $TARBALL SHA256SUMS.asc \
 && apk del gnupg

ENV HOME /
EXPOSE 8332 8333 18332 18333 29000

ENTRYPOINT ["su-exec"]

# mkdir /home/pi/btcdata ; sudo chown bitcoinuser:bitcoinuser /home/pi/btcdata
# docker run --rm -d -v /home/pi/btcdata:/.bitcoin btcnode `id -u bitcoinuser`:`id -g bitcoinuser` bitcoind
