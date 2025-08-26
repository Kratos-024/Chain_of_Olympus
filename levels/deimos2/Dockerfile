FROM alpine:latest

RUN apk add --no-cache bash python3  coreutils



RUN adduser -D -s /bin/bash deimos2 && \
    echo "deimos2:trevalquindoshar" | chpasswd

RUN echo 'alias python3="timeout 30s python3"' >> /home/deimos2/.bashrc

COPY IncPasswd.txt /home/deimos2/
RUN chown -R deimos2:deimos2 /home/deimos2

USER deimos2
WORKDIR /home/deimos2

CMD ["tail", "-f", "/dev/null"]
