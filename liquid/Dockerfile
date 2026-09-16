FROM debian:trixie-slim

ARG ELEMENTS_VERSION="23.3.4"

# x86_64, arm or aarch64
ARG ARCH

# https://github.com/ElementsProject/elements/releases/download/elements-0.18.1.3/elements-0.18.1.3-arm-linux-gnueabihf.tar.gz
# https://github.com/ElementsProject/elements/releases/download/elements-0.18.1.3/elements-0.18.1.3-aarch64-linux-gnu.tar.gz
# https://github.com/ElementsProject/elements/releases/download/elements-0.18.1.3/elements-0.18.1.3-x86_64-linux-gnu.tar.gz
# https://github.com/ElementsProject/elements/releases/download/elements-0.18.1.3/SHA256SUMS.asc

ENV URL https://github.com/ElementsProject/elements/releases/download/elements-${ELEMENTS_VERSION}

VOLUME ["/.elements"]
WORKDIR /usr/bin

RUN apt update && apt -y install wget gpg mosquitto-clients curl coreutils jq \
&& wget ${URL}/SHA256SUMS \
&& wget ${URL}/SHA256SUMS.asc \
&& gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys BD0F3062F87842410B06A0432F656B0610604482 \
&& gpg --verify SHA256SUMS.asc \
&& GNU=$([ "${ARCH}" = "arm" ] && echo eabihf || true) \
&& TARBALL=elements-${ELEMENTS_VERSION}-${ARCH}-linux-gnu${GNU}.tar.gz \
&& echo ${URL}/$TARBALL \
&& wget ${URL}/$TARBALL \
&& grep $TARBALL SHA256SUMS | sha256sum -c - \
&& tar -xzC . -f $TARBALL elements-${ELEMENTS_VERSION}/bin/elementsd elements-${ELEMENTS_VERSION}/bin/elements-cli --strip-components=2 \
&& rm -rf $TARBALL SHA256SUMS SHA256SUMS.asc \
&& apt -y remove gpg wget git && apt -y autoremove

ENV HOME /
EXPOSE 18885 18886 7041 7042 18891 18892


# docker build -t elements:v23.3.4 --build-arg ARCH=x86_64 .
# docker build -t elements:v23.3.4 --build-arg ARCH=aarch64 .
# docker build -t elements:v23.3.4 --build-arg ARCH=arm .
