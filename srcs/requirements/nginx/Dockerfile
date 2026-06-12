FROM alpine:3.23

RUN apk add nginx
RUN apk update && apk add --no-cache \
    nginx \
    iproute2-ss \
    envsubst \
    openssl

COPY ./conf/wp_nginx.conf.template /tmp/wp_nginx.conf.template
COPY ./conf/entrypoint.sh /tmp/entrypoint.sh

RUN chmod +x /tmp/entrypoint.sh

ENTRYPOINT ["/tmp/entrypoint.sh"]
