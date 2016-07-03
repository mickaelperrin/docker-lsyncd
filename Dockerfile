FROM alpine:latest

ENV DOCKERIZE_VERSION v0.2.0

# Lsyncd
RUN apk add --no-cache lsyncd bash

# Dockerize
RUN apk add --no-cache wget \
 && wget --no-check-certificate https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
 && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Entrypoint to easily enter in the container and run additionnal scripts on startup
COPY ./lsyncd-entrypoint.sh /
RUN mkdir /lsyncd-entrypoint.d \
 && chmod +x /lsyncd-entrypoint.sh

COPY ./lsyncd.conf.tpl /

CMD dockerize -template /lsyncd.conf.tpl -template /lsyncd.conf.tpl:/lsyncd.conf lsyncd -nodaemon /lsyncd.conf
ENTRYPOINT ["/lsyncd-entrypoint.sh"]
