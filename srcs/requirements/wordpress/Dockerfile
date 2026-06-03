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
    iproute2-ss \
    bash \
    fcgi \
    curl

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN echo "memory_limit=256M" >> /etc/php83/php.ini
RUN sed -i 's/listen = 127.0.0.1:9000/listen = 9000/' /etc/php83/php-fpm.d/www.conf

COPY ./conf/entrypoint.sh /tmp/entrypoint.sh
RUN chmod +x /tmp/entrypoint.sh

EXPOSE 9000

ENTRYPOINT ["/tmp/entrypoint.sh"]

