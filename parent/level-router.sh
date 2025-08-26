#!/bin/bash

USERNAME=$(whoami)
LEVEL_NUM=$(echo "$USERNAME" | sed 's/deimos//')
CONTAINER_NAME="deimos-level$LEVEL_NUM"

echo "Connecting $USERNAME to $CONTAINER_NAME..."

exec /usr/local/bin/root-exec-helper.sh "$CONTAINER_NAME"
