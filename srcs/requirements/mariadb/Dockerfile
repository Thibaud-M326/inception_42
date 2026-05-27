# FROM alpine:3.22
#
# RUN apk add mariadb mariadb-client mariadb-server-utils
#
# # VOLUME ["/var/lib/mysql"]
#
# COPY ./conf/entrypoint.sh /
# RUN chmod +x /entrypoint.sh
#
# EXPOSE 3306
#
# # RUN chown -R mysql:mysql /var/lib/mysql
#
# # USER mysql
#
# ENTRYPOINT ["./entrypoint.sh"]
#
# # CMD ["tail", "-f", "/dev/null"]
#

FROM alpine:3.22

RUN apk update && apk add --no-cache \
    mariadb \
    mariadb-client \
    mariadb-server-utils

RUN --mount

RUN mkdir -p /var/lib/mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld

COPY ./conf/entrypoint.sh /tmp/entrypoint.sh
RUN chmod +x /tmp/entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/tmp/entrypoint.sh"]
