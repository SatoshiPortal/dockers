FROM debian:latest
ARG USER_ID
ARG GROUP_ID
ARG CORE_VERSION
ENV HOME /bitcoin
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}
ENV CORE_VERSION ${CORE_VERSION:-"0.16.2"}

RUN groupadd -g ${GROUP_ID} bitcoin \
    && useradd -u ${USER_ID} -g bitcoin -s /bin/bash -m -d ${HOME} bitcoin

RUN apt-get update && apt-get install -y --no-install-recommends \
    gosu \
		curl \
		ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -O https://bitcoin.org/bin/bitcoin-core-${CORE_VERSION}/bitcoin-${CORE_VERSION}-x86_64-linux-gnu.tar.gz \
    && curl -O https://bitcoin.org/bin/bitcoin-core-${CORE_VERSION}/SHA256SUMS.asc \
    && sha256sum -c --ignore-missing SHA256SUMS.asc \
    && tar -xzC ${HOME} -f bitcoin-${CORE_VERSION}-x86_64-linux-gnu.tar.gz \
    && rm -rf bitcoin-${CORE_VERSION}-x86_64-linux-gnu.tar.gz SHA256SUMS.asc

VOLUME ["${HOME}/.bitcoin"]
EXPOSE 8332 8333 18332 18333 29000
WORKDIR ${HOME}/bitcoin-${CORE_VERSION}/bin

ENTRYPOINT ["gosu"]
CMD ["bitcoin","./bitcoind"]
