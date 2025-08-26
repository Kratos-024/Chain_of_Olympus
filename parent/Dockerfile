FROM alpine:latest

# Install SSH server, bash, curl and Docker CLI
RUN apk add --no-cache openssh bash curl shadow && \
    curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-20.10.21.tgz \
    | tar -xzC /usr/local/bin --strip-components=1 docker/docker

# Generate SSH host keys
RUN ssh-keygen -A

# Configure SSH - password auth on, no root login
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

# Create deimos0 first (special password = deimos0)
RUN adduser -D -s /usr/local/bin/level-router.sh 'deimos0' && \
    echo 'deimos0:deimos0' | chpasswd

# Copy password list
COPY pass.txt /tmp/pass.txt

# Create deimos1–7 with passwords from pass.txt
RUN for i in $(seq 1 7); do \
        adduser -D -s /usr/local/bin/level-router.sh "deimos$i" && \
        password=$(sed -n "${i}p" /tmp/pass.txt) && \
        echo "deimos$i:$password" | chpasswd; \
    done && \
    rm /tmp/pass.txt

# Copy scripts
COPY level-router.sh /usr/local/bin/level-router.sh
COPY root-exec-helper.sh /usr/local/bin/root-exec-helper.sh
COPY start.sh /start.sh

# Permissions - helper as setuid root so ssh users can call docker
RUN chmod +x /usr/local/bin/level-router.sh /usr/local/bin/root-exec-helper.sh /start.sh && \
    chown root:root /usr/local/bin/root-exec-helper.sh && \
    chmod 4755 /usr/local/bin/root-exec-helper.sh

EXPOSE 22
CMD ["/start.sh"]
