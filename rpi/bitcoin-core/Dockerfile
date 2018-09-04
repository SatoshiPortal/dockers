FROM alpine

# Taking care of glibc shit (glibc not natively supported by Alpine but Bitcoin Core uses it)

ENV GLIBC_VERSION 2.27-r0
# Download and install glibc (https://github.com/jeanblanchard/docker-alpine-glibc/blob/master/Dockerfile)
RUN apk add --update --no-cache wget \
 && wget -O glibc.apk "https://github.com/yangxuan8282/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk" \
 && wget -O glibc-bin.apk "https://github.com/yangxuan8282/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk" \
 && apk add --allow-untrusted --update --no-cache glibc-bin.apk glibc.apk \
 && /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib \
 && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf \
 && rm -rf glibc.apk glibc-bin.apk

# Now let's install Bitcoin Core

ARG USER_ID
ARG GROUP_ID
ARG CORE_VERSION

ENV USERNAME bitcoinuser
ENV HOME /${USERNAME}
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}
ENV CORE_VERSION ${CORE_VERSION:-"0.16.2"}
ENV TARBALL bitcoin-${CORE_VERSION}-arm-linux-gnueabihf.tar.gz
ENV URL https://bitcoincore.org/bin/bitcoin-core-${CORE_VERSION}

RUN addgroup -g ${GROUP_ID} ${USERNAME} \
    && adduser -u ${USER_ID} -G ${USERNAME} -D -s /bin/sh -h ${HOME} ${USERNAME}

RUN apk add --no-cache \
    su-exec \
    gnupg

VOLUME ["${HOME}/.bitcoin"]

RUN wget ${URL}/SHA256SUMS.asc \
 && gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "01EA5486DE18A882D4C2684590C8019E36C2E964" \
 && gpg --verify SHA256SUMS.asc \
 && wget ${URL}/${TARBALL} \
 && grep ${TARBALL} SHA256SUMS.asc | sha256sum -c - \
 && tar -xzC ${HOME} -f ${TARBALL} \
 && rm -rf ${TARBALL} SHA256SUMS.asc \
 && chown -R ${USERNAME}:${USERNAME} ${HOME} \
 && apk del gnupg

EXPOSE 8332 8333 18332 18333 29000
WORKDIR ${HOME}/bitcoin-${CORE_VERSION}/bin

ENTRYPOINT ["su-exec"]
CMD ["bitcoinuser","./bitcoind"]
