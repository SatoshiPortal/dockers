FROM python:3.9-alpine3.15 AS builder

ENV HOME /
ENV VERSION=v1.14.2
ENV BRANCH=v1.14.2
ENV CARGO_NET_GIT_FETCH_WITH_CLI true

RUN apk add --update --no-cache git g++ libffi-dev openssl-dev libusb-dev eudev-dev rust cargo zlib-dev postgresql-dev \
 && git clone --single-branch --branch ${BRANCH} https://github.com/cryptoadvance/specter-desktop.git \
 && cd specter-desktop

WORKDIR /specter-desktop

#RUN sed -i "s/version=\".*/version=\"$VERSION\",/" setup.py \
RUN sed -i "s/vx.y.z-get-replaced-by-release-script/${VERSION}/g; " setup.py \
 && pip3 install --upgrade pip \
 && pip3 install babel cryptography \
 && pip3 install .

FROM python:3.9-alpine3.15

ENV HOME /

RUN apk add --update --no-cache libusb-dev eudev-dev su-exec

COPY --from=builder /usr/local/lib/python3.9 /usr/local/lib/python3.9
COPY --from=builder /usr/local/bin /usr/local/bin
COPY ./entrypoint.sh /

EXPOSE 25441 25442 25443

ENTRYPOINT ["su-exec"]
