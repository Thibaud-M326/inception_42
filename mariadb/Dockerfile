FROM alpine:3.22

RUN apk update
RUN apk add mariadb mariadb-client mariadb-server-utils

# VOLUME ["/var/lib/mysql"]

COPY ./conf/entrypoint.sh /
RUN chmod +x /entrypoint.sh

EXPOSE 3306

# RUN chown -R mysql:mysql /var/lib/mysql

# USER mysql

ENTRYPOINT ["./entrypoint.sh"]

# CMD ["tail", "-f", "/dev/null"]

