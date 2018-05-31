#!/bin/bash

# Need to create lavenet network?
docker network inspect lavanet > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Creating lavanet network"
    docker network create lavanet
fi

docker-compose up -d --build
