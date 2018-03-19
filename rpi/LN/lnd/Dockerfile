# Ref.: https://github.com/lightningnetwork/lnd/blob/master/docker/lnd/Dockerfile

FROM golang:latest

ARG USER_ID
ARG GROUP_ID
ENV HOME /lnuser
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

RUN groupadd -g ${GROUP_ID} lnuser \
 && useradd -u ${USER_ID} -g lnuser -s /bin/bash -m -d ${HOME} lnuser

RUN echo 'deb http://ftp.ca.debian.org/debian jessie-backports main' > /etc/apt/sources.list.d/gosu.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends \
    gosu \
 && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Force Go to use the cgo based DNS resolver. This is required to ensure DNS
# queries required to connect to linked containers succeed.
ENV GODEBUG netdns=cgo

# Install dep to manage vendor.
RUN go get -u github.com/golang/dep/cmd/dep \

# Grab and install the latest version of lnd and all related dependencies.
 && git clone https://github.com/lightningnetwork/lnd $GOPATH/src/github.com/lightningnetwork/lnd \

# Install dependencies and install/build lnd.
 && cd $GOPATH/src/github.com/lightningnetwork/lnd \
 && dep ensure \
 && go install . ./cmd/... \
 && rm -rf $GOPATH/pkg $GOPATH/src

VOLUME ["${HOME}/.lnd"]
EXPOSE 9735 10009
WORKDIR $GOPATH/bin

ENTRYPOINT ["gosu"]
CMD ["lnuser","lnd"]
