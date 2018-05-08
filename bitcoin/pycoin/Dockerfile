FROM python:alpine

RUN apk add --update --no-cache git \
&& pip install --no-cache-dir pycoin \
&& cd && git clone https://github.com/shivaenigma/pycoin.git \
&& cp -rf pycoin/pycoin/* /usr/local/lib/python3.6/site-packages/pycoin

ENTRYPOINT ["ash"]
