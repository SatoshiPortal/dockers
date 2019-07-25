FROM python:3.6-alpine3.8

RUN apk add --update --no-cache git \
&& cd && git clone https://github.com/Kexkey/pycoin.git \
&& mkdir /usr/local/lib/python3.6/site-packages/pycoin \
&& cp -rf pycoin/pycoin/* /usr/local/lib/python3.6/site-packages/pycoin

COPY ku /usr/local/bin/ku

RUN chmod +x /usr/local/bin/ku

ENTRYPOINT ["ash"]
