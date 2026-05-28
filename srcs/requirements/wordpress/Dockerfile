FROM alpine:3.22

RUN apk update && apk add --no-cache \
    php \
    php83-fpm \
    php83-common \
    php83-phar \
    php83-curl \
    php83-openssl \
    php83-mysqli \
    curl

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN echo "memory_limit=256M" >> /etc/php83/php.ini

RUN mkdir -p /var/www/wp-site
RUN wp core download --locale=fr_FR --path=/var/www/wp-site/

CMD ["tail", "-f", "/dev/null"]


#
#
#
#
#
# install:
# php
# php83-fpm
# php83-common
# php8833-phar
# curl
#
# install wordpress cli:
# curl -o https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# chmod +x wp-cli.phar
# sudo mv wp-cli.phar /usr/local/bin/wp
#
#
# mkdir -p /var/www/wp-site
#
#
#
# echo 
#
# wp config create --dbname=wp_database --dbuser=wp_user --dbpass=motdepassdefou --dbhost=mariadb --path=/var/www/wp-site/
#
#
#
