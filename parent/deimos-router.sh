#!/bin/bash
LEVEL_NUM=${USER#deimos}

if ! sudo docker ps --format "{{.Names}}" | grep -q "^deimos${LEVEL_NUM}-container$"; then
    echo "Starting deimos${LEVEL_NUM} container..."
    sudo docker run -d --name deimos${LEVEL_NUM}-container child-deimos${LEVEL_NUM} 2>/dev/null || {
        echo "Failed to start container. Trying to start existing container..."
        sudo docker start deimos${LEVEL_NUM}-container 2>/dev/null
    }
    sleep 2
fi

echo "Connecting to deimos${LEVEL_NUM} container..."
exec sudo docker exec -it deimos${LEVEL_NUM}-container /bin/bash





