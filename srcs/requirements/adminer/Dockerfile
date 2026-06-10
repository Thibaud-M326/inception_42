FROM alpine:3.23

RUN apk update && apk add --no-cache \
    php83 \
    php83-mysqli \
    php83-session \
    curl

RUN curl -L https://www.adminer.org/latest.php -o adminer.php

CMD ["php83", "-S", "0.0.0.0:8080", "/adminer.php"]
