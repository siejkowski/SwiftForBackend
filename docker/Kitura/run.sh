#!/bin/bash

docker stop kitura-sample
docker rm -f kitura-sample

docker run -d -p 5900:5900 --privileged=true -v "$1":/project --name kitura-sample swift-for-backend:kitura 
