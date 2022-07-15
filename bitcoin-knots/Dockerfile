FROM debian:bullseye-slim

# https://bitcoinknots.org/files/22.x/22.0.knots20211108/bitcoin-22.0.knots20211108-x86_64-linux-gnu.tar.gz

ARG CORE_VERSION="22.0"
ARG KNOTS_VERSION="22.0.knots20211108"

# x86_64, arm or aarch64
ARG ARCH="aarch64"

ENV URL https://bitcoincore.org/bin/bitcoin-core-${CORE_VERSION}
ENV URL https://bitcoinknots.org/files/22.x/${KNOTS_VERSION}/guix

VOLUME ["/.bitcoin"]
WORKDIR /usr/bin

RUN apt update && apt -y install wget gpg mosquitto-clients curl coreutils jq \
&& wget ${URL}/SHA256SUMS.asc \
&& gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys "E463A93F5F3117EEDE6C7316BD02942421F4889F" \
&& gpg --verify SHA256SUMS.asc \
&& GNU=$([ "${ARCH}" = "arm" ] && echo eabihf || true) \
&& TARBALL=bitcoin-${KNOTS_VERSION}-${ARCH}-linux-gnu${GNU}.tar.gz \
&& wget ${URL}/$TARBALL \
&& grep $TARBALL SHA256SUMS.asc | sha256sum -c - \
&& tar -xzC . -f $TARBALL bitcoin-${KNOTS_VERSION}/bin/bitcoind bitcoin-${KNOTS_VERSION}/bin/bitcoin-cli --strip-components=2 \
&& rm -rf $TARBALL SHA256SUMS.asc \
&& apt -y remove gpg wget && apt -y autoremove

ENV HOME /
EXPOSE 8332 8333 18332 18333 29000
