FROM    alpine:3.13

RUN     apk update && apk upgrade && \
        apk add --no-cache nginx openssl

RUN     mkdir -p /etc/nginx/ssl
RUN     mkdir -p /run/nginx

RUN     mkdir -p /var/www/html

RUN     openssl req -newkey rsa:2048 \
        -x509 \
        -sha256 \
        -days 365 \
        -nodes \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.pem \
        -subj "/C=IT/ST=Italy/L=Rome/O=42Rome/OU=$USER/CN=$USER"

COPY    conf/nginx.conf /etc/nginx/conf.d/default.conf

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
