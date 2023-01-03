FROM debian:bullseye-slim

ARG CORE_VERSION="24.0.1"

# x86_64, arm or aarch64
ARG ARCH
ENV URL https://bitcoincore.org/bin/bitcoin-core-${CORE_VERSION}

VOLUME ["/.bitcoin"]
WORKDIR /usr/bin

RUN apt update && apt -y install wget gpg mosquitto-clients curl coreutils jq \
&& wget ${URL}/SHA256SUMS \
&& wget ${URL}/SHA256SUMS.asc \
&& wget https://raw.githubusercontent.com/Kvaciral/kvaciral/main/kvaciral.asc \
&& wget https://raw.githubusercontent.com/bitcoin/bitcoin/v${CORE_VERSION}/contrib/builder-keys/keys.txt \
&& gpg --import kvaciral.asc \
&& while read fingerprint keyholder_name; do gpg --keyserver hkps://keys.openpgp.org --recv-keys ${fingerprint}; done < ./keys.txt \
&& gpg --keyserver-options auto-key-retrieve --keyserver hkp://keyserver.ubuntu.com --verify SHA256SUMS.asc \
&& GNU=$([ "${ARCH}" = "arm" ] && echo eabihf || true) \
&& TARBALL=bitcoin-${CORE_VERSION}-${ARCH}-linux-gnu${GNU}.tar.gz \
&& wget ${URL}/$TARBALL \
&& grep $TARBALL SHA256SUMS | sha256sum -c - \
&& tar -xzC . -f $TARBALL bitcoin-${CORE_VERSION}/bin/bitcoind bitcoin-${CORE_VERSION}/bin/bitcoin-cli --strip-components=2 \
&& rm -rf $TARBALL SHA256SUMS SHA256SUMS.asc keys.txt kvaciral.asc \
&& apt -y remove gpg wget && apt -y autoremove

ENV HOME /
EXPOSE 8332 8333 18332 18333 29000
