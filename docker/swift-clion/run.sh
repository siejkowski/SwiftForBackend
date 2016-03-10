#!/bin/bash

docker stop swift-clion
docker rm -f swift-clion

docker run -d -p 5900:5900 -p 8080:8080 --privileged=true -v "$1":/project --name swift-clion swift-clion:latest
