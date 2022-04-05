FROM cyphernode/alpine-glibc-base:v3.11.0_2.29-0

# https://bitcoinknots.org/files/22.x/22.0.knots20211108/bitcoin-22.0.knots20211108-x86_64-linux-gnu.tar.gz

ARG CORE_VERSION="22.0"
ARG KNOTS_VERSION="22.0.knots20211108"

# x86_64, arm or aarch64
ARG ARCH="x86_64"

ENV URL https://bitcoincore.org/bin/bitcoin-core-${CORE_VERSION}
ENV URL https://bitcoinknots.org/files/22.x/${KNOTS_VERSION}/guix

RUN apk add --update --no-cache \
    curl \
    su-exec \
    gnupg

VOLUME ["/.bitcoin"]

WORKDIR /usr/bin

RUN wget ${URL}/SHA256SUMS.asc \
 && gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys "E463A93F5F3117EEDE6C7316BD02942421F4889F" \
 && gpg --verify SHA256SUMS.asc \
 && GNU=$([ "${ARCH}" = "arm" ] && echo eabihf || true) \
 && TARBALL=bitcoin-${KNOTS_VERSION}-${ARCH}-linux-gnu${GNU}.tar.gz \
 && wget ${URL}/$TARBALL \
 && grep $TARBALL SHA256SUMS.asc | sha256sum -c - \
 && tar -xzC . -f $TARBALL bitcoin-${KNOTS_VERSION}/bin/bitcoind bitcoin-${KNOTS_VERSION}/bin/bitcoin-cli --strip-components=2 \
 && rm -rf $TARBALL SHA256SUMS.asc \
 && apk del gnupg

ENV HOME /
EXPOSE 8332 8333 18332 18333 29000

ENTRYPOINT ["su-exec"]

# mkdir /home/pi/btcdata ; sudo chown bitcoinuser:bitcoinuser /home/pi/btcdata
# docker run --rm -d -v /home/pi/btcdata:/.bitcoin btcnode `id -u bitcoinuser`:`id -g bitcoinuser` bitcoind
