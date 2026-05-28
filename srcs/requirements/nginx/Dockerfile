FROM alpine:3.22

ARG DOMAIN_NAME=localhost

RUN apk add --no-cache nginx openssl && \
    mkdir -p /etc/nginx/ssl /var/lib/nginx /run/nginx && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
      -keyout /etc/nginx/ssl/inception.key \
      -out /etc/nginx/ssl/inception.crt \
      -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=Inception/CN=${DOMAIN_NAME}"

COPY conf/default.conf /etc/nginx/http.d/default.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
