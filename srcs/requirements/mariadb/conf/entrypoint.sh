#!/bin/sh
set -e

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Initialise seulement si la base n'existe pas encore
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
