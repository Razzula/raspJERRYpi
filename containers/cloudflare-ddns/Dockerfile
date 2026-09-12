FROM alpine:latest

RUN apk add --no-cache curl jq

COPY data/update.sh /update.sh
RUN chmod +x /update.sh

CMD ["/update.sh"]
