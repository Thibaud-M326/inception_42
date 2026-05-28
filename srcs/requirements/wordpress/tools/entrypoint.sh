#!/bin/sh
set -eu

read_secret() {
  secret_path=$1
  if [ ! -f "$secret_path" ]; then
    echo "Missing secret file: $secret_path" >&2
    exit 1
  fi
  tr -d '\r\n' < "$secret_path"
}

required_var() {
  var_name=$1
  eval "value=\${$var_name:-}"
  if [ -z "$value" ]; then
    echo "$var_name is required" >&2
    exit 1
  fi
}

for var in \
  DOMAIN_NAME \
  WORDPRESS_DB_HOST \
  WORDPRESS_DB_NAME \
  WORDPRESS_DB_USER \
  WORDPRESS_DB_PASSWORD_FILE \
  WORDPRESS_TITLE \
  WORDPRESS_ADMIN_USER \
  WORDPRESS_ADMIN_EMAIL \
  WORDPRESS_ADMIN_PASSWORD_FILE \
  WORDPRESS_USER \
  WORDPRESS_USER_EMAIL \
  WORDPRESS_USER_PASSWORD_FILE
do
  required_var "$var"
done

case "$WORDPRESS_ADMIN_USER" in
  *admin*|*Admin*|*administrator*|*Administrator*)
    echo "WORDPRESS_ADMIN_USER must not contain admin or administrator" >&2
    exit 1
    ;;
esac

DB_PASSWORD=$(read_secret "$WORDPRESS_DB_PASSWORD_FILE")
ADMIN_PASSWORD=$(read_secret "$WORDPRESS_ADMIN_PASSWORD_FILE")
USER_PASSWORD=$(read_secret "$WORDPRESS_USER_PASSWORD_FILE")

mkdir -p /var/www/html /run/php

if [ ! -f /var/www/html/wp-settings.php ]; then
  cp -a /usr/src/wordpress/. /var/www/html/
fi

chown -R nobody:nobody /var/www/html /run/php

echo "Waiting for MariaDB at ${WORDPRESS_DB_HOST}..."
for attempt in $(seq 1 60); do
  if mariadb-admin ping \
      --host="$WORDPRESS_DB_HOST" \
      --user="$WORDPRESS_DB_USER" \
      --password="$DB_PASSWORD" \
      --silent >/dev/null 2>&1; then
    break
  fi
  if [ "$attempt" -eq 60 ]; then
    echo "MariaDB is not reachable" >&2
    exit 1
  fi
  sleep 2
done

if [ ! -f /var/www/html/wp-config.php ]; then
  wp config create \
    --allow-root \
    --dbname="$WORDPRESS_DB_NAME" \
    --dbuser="$WORDPRESS_DB_USER" \
    --dbpass="$DB_PASSWORD" \
    --dbhost="$WORDPRESS_DB_HOST" \
    --path=/var/www/html
fi

if ! wp core is-installed --allow-root --path=/var/www/html >/dev/null 2>&1; then
  wp core install \
    --allow-root \
    --path=/var/www/html \
    --url="https://${DOMAIN_NAME}" \
    --title="$WORDPRESS_TITLE" \
    --admin_user="$WORDPRESS_ADMIN_USER" \
    --admin_password="$ADMIN_PASSWORD" \
    --admin_email="$WORDPRESS_ADMIN_EMAIL" \
    --skip-email
fi

if ! wp user get "$WORDPRESS_USER" --allow-root --path=/var/www/html >/dev/null 2>&1; then
  wp user create "$WORDPRESS_USER" "$WORDPRESS_USER_EMAIL" \
    --allow-root \
    --path=/var/www/html \
    --role=author \
    --user_pass="$USER_PASSWORD"
fi

chown -R nobody:nobody /var/www/html

exec php-fpm84 -F
