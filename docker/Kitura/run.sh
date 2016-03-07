#!/bin/bash

docker stop kitura-sample
docker rm -f kitura-sample

docker run -it --privileged=true -v "$1":/project --name kitura-sample swift-for-backend:kitura /bin/bash
