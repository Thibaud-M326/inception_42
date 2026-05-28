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

validate_identifier() {
  value=$1
  name=$2
  case "$value" in
    ""|*[!A-Za-z0-9_]*)
      echo "$name must contain only letters, numbers, and underscores" >&2
      exit 1
      ;;
  esac
}

sql_escape() {
  printf "%s" "$1" | sed "s/'/''/g"
}

: "${MYSQL_DATABASE:?MYSQL_DATABASE is required}"
: "${MYSQL_USER:?MYSQL_USER is required}"
: "${MYSQL_ROOT_PASSWORD_FILE:?MYSQL_ROOT_PASSWORD_FILE is required}"
: "${MYSQL_PASSWORD_FILE:?MYSQL_PASSWORD_FILE is required}"

validate_identifier "$MYSQL_DATABASE" "MYSQL_DATABASE"
validate_identifier "$MYSQL_USER" "MYSQL_USER"

MYSQL_ROOT_PASSWORD=$(read_secret "$MYSQL_ROOT_PASSWORD_FILE")
MYSQL_PASSWORD=$(read_secret "$MYSQL_PASSWORD_FILE")
MYSQL_ROOT_PASSWORD_SQL=$(sql_escape "$MYSQL_ROOT_PASSWORD")
MYSQL_PASSWORD_SQL=$(sql_escape "$MYSQL_PASSWORD")

mkdir -p /run/mysqld /var/lib/mysql
chown -R mysql:mysql /run/mysqld /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql --skip-test-db >/dev/null
fi

cat >/tmp/mariadb-init.sql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD_SQL}';
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD_SQL}';
ALTER USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD_SQL}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

exec mariadbd \
  --user=mysql \
  --datadir=/var/lib/mysql \
  --bind-address=0.0.0.0 \
  --init-file=/tmp/mariadb-init.sql
