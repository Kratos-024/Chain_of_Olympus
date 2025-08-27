FROM alpine:latest

# Install SSH server, bash, curl and Docker CLI
RUN apk add --no-cache openssh sudo bash curl shadow && \
    curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-20.10.21.tgz \
    | tar -xzC /usr/local/bin --strip-components=1 docker/docker

# Generate SSH host keys
RUN ssh-keygen -A

# Configure SSH - password auth on, no root login
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

RUN adduser -D -s /bin/bash deimos0 && \
    echo "deimos0:deimos0" | chpasswd

# Create all other users with their specific passwords
RUN adduser -D -s /bin/bash deimos1 && echo "deimos1:zorivankelthura" | chpasswd && \
    adduser -D -s /bin/bash deimos2 && echo "deimos2:mivorandusklethe" | chpasswd && \
    adduser -D -s /bin/bash deimos3 && echo "deimos3:trevalquindoshar" | chpasswd && \
    adduser -D -s /bin/bash deimos4 && echo "deimos4:9bdc9763b08af007ba2db5221c3e9c7d04210dc62dfe4bc999864788b1917ff1" | chpasswd && \
    adduser -D -s /bin/bash deimos5 && echo "deimos5:dravenquorlithas" | chpasswd && \
    adduser -D -s /bin/bash deimos6 && echo "deimos6:kalvorithenquast" | chpasswd && \
    adduser -D -s /bin/bash deimos7 && echo "deimos7:threnovaridusk" | chpasswd 

# Give wheel sudo access to docker
RUN echo '%wheel ALL=(ALL) NOPASSWD: /usr/local/bin/docker' >> /etc/sudoers && \
    for i in $(seq 0 7); do adduser "deimos$i" wheel; done

# Copy scripts
COPY deimos-router.sh /usr/local/bin/
COPY start.sh /start.sh


RUN chmod +x /usr/local/bin/deimos-router.sh /start.sh && \
    for i in $(seq 0 7); do \
        sed -i "s|deimos$i:/bin/bash|deimos$i:/usr/local/bin/deimos-router.sh|" /etc/passwd; \
    done

EXPOSE 22
CMD ["/start.sh"]




