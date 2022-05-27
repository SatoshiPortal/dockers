FROM cyphernode/alpine-glibc-base:v3.12.4_2.31-0

ARG CORE_VERSION="23.0"

# x86_64, arm or aarch64
ARG ARCH
ENV URL https://bitcoincore.org/bin/bitcoin-core-${CORE_VERSION}

RUN apk add --update --no-cache \
    curl \
    su-exec \
    gnupg

VOLUME ["/.bitcoin"]

WORKDIR /usr/bin

RUN wget ${URL}/SHA256SUMS \
 && wget ${URL}/SHA256SUMS.asc \
 && wget https://raw.githubusercontent.com/Kvaciral/kvaciral/main/kvaciral.asc \
 && gpg --import kvaciral.asc \
 && wget https://raw.githubusercontent.com/bitcoin/bitcoin/v${CORE_VERSION}/contrib/builder-keys/keys.txt \
 && while read fingerprint keyholder_name; do gpg --keyserver hkps://keys.openpgp.org --recv-keys ${fingerprint}; done < ./keys.txt \
 && gpg --keyserver-options auto-key-retrieve --keyserver hkp://keyserver.ubuntu.com --verify SHA256SUMS.asc \
 && GNU=$([ "${ARCH}" = "arm" ] && echo eabihf || true) \
 && TARBALL=bitcoin-${CORE_VERSION}-${ARCH}-linux-gnu${GNU}.tar.gz \
 && wget ${URL}/$TARBALL \
 && grep $TARBALL SHA256SUMS | sha256sum -c - \
 && tar -xzC . -f $TARBALL bitcoin-${CORE_VERSION}/bin/bitcoind bitcoin-${CORE_VERSION}/bin/bitcoin-cli --strip-components=2 \
 && rm -rf $TARBALL SHA256SUMS SHA256SUMS.asc kvaciral.asc \
 && apk del gnupg

ENV HOME /
EXPOSE 8332 8333 18332 18333 29000

ENTRYPOINT ["su-exec"]

# mkdir /home/pi/btcdata ; sudo chown bitcoinuser:bitcoinuser /home/pi/btcdata
# docker run --rm -d -v /home/pi/btcdata:/.bitcoin btcnode `id -u bitcoinuser`:`id -g bitcoinuser` bitcoind
