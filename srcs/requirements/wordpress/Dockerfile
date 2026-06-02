FROM alpine:3.22

RUN apk update && apk add --no-cache \
    php \
    php83-fpm \
    php83-common \
    php83-phar \
    php83-curl \
    php83-openssl \
    php83-mysqli \
    php83-iconv \
    php83-mbstring \
    bash \
    curl

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN echo "memory_limit=256M" >> /etc/php83/php.ini

COPY ./conf/entrypoint.sh /tmp/entrypoint.sh
RUN chmod +x /tmp/entrypoint.sh

ENTRYPOINT ["/tmp/entrypoint.sh"]

