FROM debian:bullseye-slim

ARG ELEMENTS_VERSION="0.21.0.2"

# x86_64, arm or aarch64
ARG ARCH=aarch64

# https://github.com/ElementsProject/elements/releases/download/elements-0.18.1.3/elements-0.18.1.3-arm-linux-gnueabihf.tar.gz
# https://github.com/ElementsProject/elements/releases/download/elements-0.18.1.3/elements-0.18.1.3-aarch64-linux-gnu.tar.gz
# https://github.com/ElementsProject/elements/releases/download/elements-0.18.1.3/elements-0.18.1.3-x86_64-linux-gnu.tar.gz
# https://github.com/ElementsProject/elements/releases/download/elements-0.18.1.3/SHA256SUMS.asc

ENV URL https://github.com/ElementsProject/elements/releases/download/elements-${ELEMENTS_VERSION}

VOLUME ["/.elements"]
WORKDIR /usr/bin

RUN apt update && apt -y install wget gpg mosquitto-clients curl coreutils jq \
 && wget ${URL}/SHA256SUMS.asc \
 && gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 11D43A27826A421212108BF66BE2CED14A9917BC DE10E82629A8CAD55B700B972F2A88D7F8D68E87 \
 && gpg --verify SHA256SUMS.asc \
 && GNU=$([ "${ARCH}" = "arm" ] && echo eabihf || true) \
 && TARBALL=elements-elements-${ELEMENTS_VERSION}-${ARCH}-linux-gnu${GNU}.tar.gz \
 && echo ${URL}/$TARBALL \
 && wget ${URL}/$TARBALL \
 && grep $TARBALL SHA256SUMS.asc | sha256sum -c - \
 && tar -xzC . -f $TARBALL elements-elements-${ELEMENTS_VERSION}/bin/elementsd elements-elements-${ELEMENTS_VERSION}/bin/elements-cli --strip-components=2 \
 && rm -rf $TARBALL SHA256SUMS.asc \
 && apt -y remove gpg wget && apt -y autoremove

ENV HOME /
EXPOSE 18885 18886 7041 7042 18891 18892
