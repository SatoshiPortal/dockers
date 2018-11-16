FROM python:3.6-alpine3.8

ARG USER_ID
ARG GROUP_ID
ENV USERNAME otsuser
ENV HOME /${USERNAME}
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

RUN addgroup -g ${GROUP_ID} ${USERNAME} \
    && adduser -u ${USER_ID} -G ${USERNAME} -D -s /bin/sh -h ${HOME} ${USERNAME} \
    && apk add --update --no-cache git g++ libressl-dev

RUN git clone https://github.com/opentimestamps/opentimestamps-client.git \
&& cd opentimestamps-client \
&& python3 setup.py install

USER ${USERNAME}
WORKDIR ${HOME}

ENTRYPOINT ["ash"]
