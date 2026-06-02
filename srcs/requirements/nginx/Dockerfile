FROM alpine:3.22

RUN apk add nginx
RUN apk update && apk add --no-cache \
    nginx \
    openssl

ENV DOMAIN="thmaitre.42.fr"

RUN  mkdir -p /etc/nginx/ssl/

RUN openssl req -x509 -nodes -newkey rsa:4096 -days 3650 \
    -keyout /etc/nginx/ssl/$DOMAIN.key \
    -out /etc/nginx/ssl/$DOMAIN.crt \
    -sha256 \
    -subj "/CN=$DOMAIN"

CMD ["tail", "-f", "/dev/null"]
