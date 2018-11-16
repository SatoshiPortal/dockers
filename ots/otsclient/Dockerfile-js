FROM node:11.1-alpine3.8

RUN apk add --update --no-cache \
    git \
    su-exec \
 && yarn global add javascript-opentimestamps

WORKDIR /otsfiles

ENTRYPOINT ["su-exec"]
# docker build -t otsclient-js -f Dockerfile-js .
# docker run -it --rm --name otsclient-js -v /home/debian/otsfiles:/otsfiles otsclient-js `id -u otsuser`:`id -g otsuser` ash

# ots-cli.js stamp -d 1ddfb769eb0b8876bc570e25580e6a53afcf973362ee1ee4b54a807da2e5eed7
# ots-cli.js verify -d 1ddfb769eb0b8876bc570e25580e6a53afcf973362ee1ee4b54a807da2e5eed7 1ddfb769eb0b8876bc570e25580e6a53afcf973362ee1ee4b54a807da2e5eed7.ots
# ots-cli.js info 1ddfb769eb0b8876bc570e25580e6a53afcf973362ee1ee4b54a807da2e5eed7.ots
# ots-cli.js upgrade 1ddfb769eb0b8876bc570e25580e6a53afcf973362ee1ee4b54a807da2e5eed7.ots
