FROM alpine:3.22

RUN apk add --no-cache \
    mariadb \
    mariadb-client \
    mariadb-server-utils

RUN mkdir -p /var/lib/mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld

COPY conf/entrypoint.sh /usr/local/bin/mariadb-entrypoint.sh
RUN chmod +x /usr/local/bin/mariadb-entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/mariadb-entrypoint.sh"]
