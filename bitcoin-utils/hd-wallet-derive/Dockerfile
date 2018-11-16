FROM php:alpine3.8

RUN apk add --update --no-cache git gmp gmp-dev \
&& cd && git clone https://github.com/dan-da/hd-wallet-derive.git \
&& cd hd-wallet-derive \
&& php -r "readfile('https://getcomposer.org/installer');" | php \
&& docker-php-ext-install gmp \
&& php composer.phar install

WORKDIR /root/hd-wallet-derive

ENTRYPOINT ["ash"]
