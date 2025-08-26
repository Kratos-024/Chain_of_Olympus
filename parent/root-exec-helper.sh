#!/bin/bash
CONTAINER_NAME="$1"
echo "Debug: received container name: $CONTAINER_NAME"

if docker ps --format '{{.Names}}' | grep -q "^$CONTAINER_NAME$"; then
    echo "Debug: container $CONTAINER_NAME is running"
    exec docker exec -it "$CONTAINER_NAME" /bin/bash
else
    echo "Debug: container $CONTAINER_NAME not found or not running"
    echo "Debug: available containers:"
    docker ps --format '{{.Names}}'
    exit 1
fi
