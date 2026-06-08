#!/bin/bash

set -e

locale="fr_FR"
site_path="/var/www/wp_site/"
db_name="wp_database"
db_user="wp_user"
#secret
db_pass="motdepassdefou"
db_host="mariadb"
site_url="https://thmaitre.42.fr"
site_title="mon site inception"
#secret
admin_user="thmaitrepanel"
#secret
admin_pass="thmaitrepanelpass"
#secret
admin_email="thmaitre@domaine.fr"

user_name="lol_user"
user_pass="lol_user_pass"
user_email="lol@domaine.fr"

mkdir -p /var/www/wp_site

if [ ! -f /var/www/wp_site/wp-config.php ]; then
  wp core download --locale="$locale" --path="$site_path"
  wp config create --dbname="$db_name" --dbuser="$db_user" --dbpass="$db_pass" --dbhost="$db_host" --path="$site_path" --allow-root
  wp core install --url="$site_url" --title="$site_title" --admin_user="$admin_user" --admin_password="$admin_pass" --admin_email="$admin_email" --path="$site_path" --allow-root
  echo "wp installation done"

  wp user create ${user_name} ${user_email} --user_pass=${user_pass} --role=author --path=${site_path} --allow-root
  echo "user ${user_name} created"
fi

echo "Install done!"

exec php-fpm83 -F
