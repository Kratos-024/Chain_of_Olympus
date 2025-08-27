#!/bin/bash
echo "Starting SSH daemon..."
/usr/sbin/sshd  &
sleep 2

echo "=== USER PASSWORDS ==="
echo "deimos0: deimos0"
i=1
while read -r pass; do
    echo "deimos$i: $pass"
    i=$((i+1))
done < /tmp/pass.txt
echo "======================"
echo

echo "=== Docker Socket Debug ==="
if [ -S /var/run/docker.sock ]; then
    ls -la /var/run/docker.sock
    DOCKER_GID=$(stat -c %g /var/run/docker.sock)
    echo "Docker socket GID: $DOCKER_GID"

    if ! getent group docker >/dev/null; then
        addgroup -g $DOCKER_GID docker
    else
        groupmod -g $DOCKER_GID docker 2>/dev/null || echo "Could not change docker group GID"
    fi

    for i in $(seq 0 2); do
        adduser deimos$i docker 2>/dev/null || echo "Could not add deimos$i to docker group"
    done

    echo "Updated group memberships"
else
    echo "Docker socket not found"
fi

# Test Docker access as root
echo "Testing Docker access as root..."
if docker info >/dev/null 2>&1; then
    echo "✓ Docker daemon accessible as root"

    echo "Starting deimos containers..."
    for i in $(seq 0 2); do
        echo "Starting deimos${i} container..."
        if docker run -d --name deimos${i}-container child-deimos${i} 2>/dev/null; then
            echo "✓ deimos${i} container started"
        else
            echo "✗ deimos${i} container failed to start (may already exist)"
            docker start deimos${i}-container 2>/dev/null && echo "  → deimos${i} container restarted"
        fi
    done
else
    echo "✗ Docker daemon not accessible"
fi

tail -f /dev/null



