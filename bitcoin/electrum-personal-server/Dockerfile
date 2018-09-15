FROM python:alpine

# Get belchers pubkey
RUN wget https://raw.githubusercontent.com/chris-belcher/electrum-personal-server/master/pgp/pubkeys/belcher.asc

# Latest release of electum private server from https://github.com/chris-belcher/electrum-personal-server/releases
ENV VERSION 0.1.5

RUN wget https://github.com/chris-belcher/electrum-personal-server/releases/download/eps-v${VERSION}/eps-v${VERSION}.tar.gz.asc
RUN wget https://github.com/chris-belcher/electrum-personal-server/archive/eps-v${VERSION}.tar.gz

RUN apk add --no-cache gnupg
RUN gpg --import belcher.asc
RUN gpg --batch --verify eps-v${VERSION}.tar.gz.asc eps-v${VERSION}.tar.gz

RUN tar -xvf eps-v${VERSION}.tar.gz 
RUN mv electrum-personal-server-eps-v${VERSION}/ eps

WORKDIR eps
COPY config.cfg config.cfg

CMD ["./server.py"]