FROM alpine:latest

WORKDIR /

RUN apk --no-cache add lftp
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]