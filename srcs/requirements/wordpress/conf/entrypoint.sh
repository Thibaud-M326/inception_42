#!/bin/bash

set -e

LOCAL=$LOCAL
WP_DB_HOST=$WP_DB_HOST
DOMAIN_NAME=https://${DOMAIN_NAME}
WP_SITE_TITLE=$WP_SITE_TITLE
WP_DB_NAME=$(cat $WP_DB_NAME_FILE)
WP_DB_USER=$(cat $WP_DB_USER_FILE)
WP_DB_PASS=$(cat $WP_DB_PASS_FILE)
WP_ADMIN_NAME=$(cat $WP_ADMIN_NAME_FILE)
WP_ADMIN_PASS=$(cat $WP_ADMIN_PASS_FILE)
WP_ADMIN_EMAIL=$(cat $WP_ADMIN_EMAIL_FILE)
WP_USER_NAME=$(cat $WP_USER_NAME_FILE)
WP_USER_PASS=$(cat $WP_USER_PASS_FILE)
WP_USER_EMAIL=$(cat $WP_USER_EMAIL_FILE)

mkdir -p /var/www/wp_site

echo ${DOMAIN_NAME}

if [ ! -f /var/www/wp_site/wp-config.php ]; then
  wp core download --locale="$LOCAL"

  wp config create --dbname="$WP_DB_NAME" \
    --dbuser="$WP_DB_USER" \
    --dbpass="$WP_DB_PASS" \
    --dbhost="$WP_DB_HOST" \
    --allow-root

  wp core install --url="$DOMAIN_NAME" \
    --title="$WP_SITE_TITLE" \
    --admin_user="$WP_ADMIN_NAME" \
    --admin_password="$WP_ADMIN_PASS" \
    --admin_email="$WP_ADMIN_EMAIL" \
    --allow-root

  echo "WordPress installation done"

  wp user create $WP_USER_NAME $WP_USER_EMAIL \
    --user_pass=$WP_USER_PASS \
    --role=author --allow-root

  echo "user ${user_name} created"
fi

echo "Install done!"

exec php-fpm83 -F
