FROM python:3.8.6-alpine3.12 AS builder

ENV HOME /
ENV VERSION=v1.3.1
ENV BRANCH=v1.3.1

RUN apk add --update --no-cache git g++ libffi-dev openssl-dev libusb-dev eudev-dev \
 && git clone --single-branch --branch ${BRANCH} https://github.com/cryptoadvance/specter-desktop.git \
 && cd specter-desktop

WORKDIR /specter-desktop

RUN sed -i "s/vx.y.z-get-replaced-by-release-script/${VERSION}/g; " setup.py \
 && pip3 install .

FROM python:3.8.6-alpine3.12

ENV HOME /

RUN apk add --update --no-cache libusb-dev eudev-dev su-exec

COPY --from=builder /usr/local/lib/python3.8 /usr/local/lib/python3.8
COPY --from=builder /usr/local/bin /usr/local/bin
COPY ./entrypoint.sh /

EXPOSE 25441 25442 25443 

ENTRYPOINT ["su-exec"]
