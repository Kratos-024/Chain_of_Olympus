FROM alpine:latest

RUN apk add --no-cache bash python3  coreutils 


RUN adduser -D -s /bin/bash deimos1 && \
    echo "deimos1:zorivankelthura" | chpasswd

RUN echo 'alias python3="timeout 30s python3"' >> /home/deimos1/.bashrc

COPY encryptThenDecrypt.txt /home/deimos1/
RUN chown -R deimos1:deimos1 /home/deimos1

USER deimos1
WORKDIR /home/deimos1

CMD ["tail", "-f", "/dev/null"]
