#!/bin/sh
set -e

get_secret() {
	local secret_name=$1
	local default_value=$2
	if [ -f "/run/secrets/${secret_name}" ]; then
		cat "/run/secrets/${secret_name}"
	else
		echo "$default_value"
	fi
}

mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

MYSQL_ROOT_PASSWORD=$(cat $MYSQL_ROOT_PASSWORD_FILE)
MYSQL_WP_PASSWORD=$(cat $MYSQL_WP_PASSWORD_FILE)

cat <<EOF >/var/lib/mysql/init.sql
CREATE DATABASE IF NOT EXISTS ${MYSQL_WP_DATABASE};

CREATE USER IF NOT EXISTS '${MYSQL_WP_USER}'@'%' IDENTIFIED BY '${MYSQL_WP_PASSWORD}';

GRANT ALL PRIVILEGES ON ${MYSQL_WP_DATABASE}.* TO '${MYSQL_WP_USER}'@'%';

FLUSH PRIVILEGES;
EOF

echo "bind-address=0.0.0.0" >>/etc/my.cnf.d/mariadb-server.cnf

exec mariadbd --user=mysql --datadir=/var/lib/mysql --init-file=/var/lib/mysql/init.sql
