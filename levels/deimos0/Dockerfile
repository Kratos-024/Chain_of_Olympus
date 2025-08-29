FROM alpine:latest

RUN apk add --no-cache bash

RUN adduser -D -s /bin/bash deimos0 && \
    echo 'deimos0:deimos0' | chpasswd

# inside deimos0/Dockerfile
COPY deimos0/welcome.txt deimos0/instructions.txt deimos0/password.txt /home/deimos0/

# Set proper ownership and permissions
RUN chown -R deimos0:deimos0 /home/deimos0 && \
    chmod 755 /home/deimos0 && \
    chmod 644 /home/deimos0/*.txt && \
    chmod 755 /home
    
USER deimos0
WORKDIR /home/deimos0

CMD ["/bin/bash", "-c", "tail -f /dev/null"]
