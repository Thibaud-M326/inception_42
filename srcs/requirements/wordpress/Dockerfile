FROM alpine:3.22

RUN apk add --no-cache \
    curl \
    mariadb-client \
    php84 \
    php84-curl \
    php84-dom \
    php84-exif \
    php84-fileinfo \
    php84-fpm \
    php84-iconv \
    php84-mbstring \
    php84-mysqli \
    php84-openssl \
    php84-phar \
    php84-session \
    php84-tokenizer \
    php84-xml \
    php84-zip && \
    ln -sf /usr/bin/php84 /usr/bin/php && \
    ln -sf /usr/sbin/php-fpm84 /usr/sbin/php-fpm

RUN curl -fsSL https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
      -o /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp && \
    mkdir -p /usr/src/wordpress /var/www/html /run/php && \
    wp core download --allow-root --path=/usr/src/wordpress --version=6.8.1

COPY conf/www.conf /etc/php84/php-fpm.d/www.conf
COPY tools/entrypoint.sh /usr/local/bin/wordpress-entrypoint.sh
RUN chmod +x /usr/local/bin/wordpress-entrypoint.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/wordpress-entrypoint.sh"]
