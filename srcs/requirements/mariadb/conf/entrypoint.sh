#!/bin/sh
set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

get_secret() {
  local secret_name=$1
  local default_value=$2
  if [ -f "/run/secrets/${secret_name}" ]; then
    cat "/run/secrets/${secret_name}"
  else
    echo "$default_value"
  fi
}

MYSQL_PASSWORD=$(get_secret "mysql_wp_password.txt" "wp_fallback_pass")

if [ ! -d "/var/lib/mysql/mysql" ]; then
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

cat <<EOF >/var/lib/mysql/init.sql
CREATE DATABASE IF NOT EXISTS wp_database;

CREATE USER IF NOT EXISTS 'wp_user'@'%' IDENTIFIED BY 'motdepasse';

GRANT ALL PRIVILEGES ON wp_database.* TO 'wp_user'@'%';

FLUSH PRIVILEGES;
EOF

exec mariadbd --user=mysql --datadir=/var/lib/mysql --init-file=/var/lib/mysql/init.sql
