#!/bin/sh

set -e

mkdir -p /etc/nginx/ssl/

openssl req -x509 -nodes -newkey rsa:4096 -days 3650 \
	-keyout /etc/nginx/ssl/${DOMAIN_NAME}.key \
	-out /etc/nginx/ssl/${DOMAIN_NAME}.crt \
	-sha256 \
	-subj "/CN=${DOMAIN_NAME}/OU=42/O=42/L=Lyon/ST=AuvergneRhoneAlpes/C=FR" \
	-addext "subjectAltName=DNS:${DOMAIN_NAME}"

mkdir -p /etc/nginx/http.d/

envsubst '$DOMAIN_NAME' </tmp/wp_nginx.conf.template >/etc/nginx/http.d/wp_nginx.conf

echo "Install done!"

exec nginx -g "daemon off;"
