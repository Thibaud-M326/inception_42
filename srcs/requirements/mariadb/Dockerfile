FROM alpine:3.23

RUN apk update && apk add --no-cache \
    mariadb \
    mariadb-client \
    mariadb-server-utils

RUN mkdir -p /var/lib/mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld

COPY ./conf/entrypoint.sh /tmp/entrypoint.sh
COPY ./conf/mariadb-server.cnf /tmp/mariadb-server.cnf
RUN chmod +x /tmp/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/tmp/entrypoint.sh"]
