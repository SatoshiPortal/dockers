FROM debian:bullseye-slim

ARG CORE_VERSION="26.0"

# x86_64, arm or aarch64
ARG ARCH
ENV URL https://bitcoincore.org/bin/bitcoin-core-${CORE_VERSION}

VOLUME ["/.bitcoin"]
WORKDIR /usr/bin

RUN apt update && apt -y install wget gpg mosquitto-clients curl coreutils jq git \
&& wget ${URL}/SHA256SUMS \
&& wget ${URL}/SHA256SUMS.asc \
&& git clone https://github.com/bitcoin-core/guix.sigs \
&& gpg --import guix.sigs/builder-keys/* \
&& gpg --verify SHA256SUMS.asc \
&& GNU=$([ "${ARCH}" = "arm" ] && echo eabihf || true) \
&& TARBALL=bitcoin-${CORE_VERSION}-${ARCH}-linux-gnu${GNU}.tar.gz \
&& wget ${URL}/$TARBALL \
&& grep $TARBALL SHA256SUMS | sha256sum -c - \
&& tar -xzC . -f $TARBALL bitcoin-${CORE_VERSION}/bin/bitcoind bitcoin-${CORE_VERSION}/bin/bitcoin-cli --strip-components=2 \
&& rm -rf $TARBALL SHA256SUMS SHA256SUMS.asc keys.txt guix.sigs \
&& apt -y remove gpg wget git && apt -y autoremove

ENV HOME /
EXPOSE 8332 8333 18332 18333 29000
