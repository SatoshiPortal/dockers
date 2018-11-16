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

USER ${USERNAME}
WORKDIR ${HOME}

RUN git clone https://github.com/opentimestamps/opentimestamps-server.git \
&& cd opentimestamps-server \
&& pip3 install --user -r requirements.txt \
&& pip3 install --user requests \
&& mkdir -p ~/.otsd/ ~/.bitcoin/

VOLUME ["${HOME}/.bitcoin"]
VOLUME ["${HOME}/otsd"]

# Must not expose here if wanting to run more than 1 server on the same machine
#EXPOSE 14788

ENTRYPOINT ["./opentimestamps-server/otsd"]
CMD [ "--rpc-address","otsnode"]
