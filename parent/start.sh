#!/bin/bash
set -e

echo "=== Starting Secure SSH Router ==="

if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    echo "Generating SSH host keys..."
    ssh-keygen -A
fi

# Just in case, ensure SSH config correct
sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config

echo "=== Starting SSH Service ==="
echo "SSH available for users: deimos0 through deimos7"

exec /usr/sbin/sshd -D -e
