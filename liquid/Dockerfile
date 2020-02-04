FROM cyphernode/alpine-glibc-base:v3.11.0_2.29-0

ARG ELEMENTS_VERSION="0.18.1.3"

# x86_64, arm or aarch64
ARG ARCH

# https://github.com/ElementsProject/elements/releases/download/elements-0.18.1.3/elements-0.18.1.3-arm-linux-gnueabihf.tar.gz
# https://github.com/ElementsProject/elements/releases/download/elements-0.18.1.3/elements-0.18.1.3-aarch64-linux-gnu.tar.gz
# https://github.com/ElementsProject/elements/releases/download/elements-0.18.1.3/elements-0.18.1.3-x86_64-linux-gnu.tar.gz
# https://github.com/ElementsProject/elements/releases/download/elements-0.18.1.3/SHA256SUMS.asc

ENV URL https://github.com/ElementsProject/elements/releases/download/elements-${ELEMENTS_VERSION}

RUN apk add --update --no-cache \
    curl \
    su-exec \
    gnupg

VOLUME ["/.elements"]

WORKDIR /usr/bin

RUN wget ${URL}/SHA256SUMS.asc \
 && gpg --recv-keys 17A985E3CF2C185F6FA87E95F3F68E2D86A48FDB \
 && gpg --verify SHA256SUMS.asc \
 && GNU=$([ "${ARCH}" = "arm" ] && echo eabihf || true) \
 && TARBALL=elements-${ELEMENTS_VERSION}-${ARCH}-linux-gnu${GNU}.tar.gz \
 && echo ${URL}/$TARBALL \
 && wget ${URL}/$TARBALL \
 && grep $TARBALL SHA256SUMS.asc | sha256sum -c - \
 && tar -xzC . -f $TARBALL elements-${ELEMENTS_VERSION}/bin/elementsd elements-${ELEMENTS_VERSION}/bin/elements-cli --strip-components=2 \
 && rm -rf $TARBALL SHA256SUMS.asc \
 && apk del gnupg

ENV HOME /
EXPOSE 18888 18889 18884 18886

ENTRYPOINT ["su-exec"]
