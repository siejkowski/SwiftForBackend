#!/bin/bash

docker rmi -f swift-for-backend:kitura

docker build -f Dockerfile -t swift-for-backend:kitura .
