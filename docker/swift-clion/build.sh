#!/bin/bash

docker rmi -f swift-clion:latest

docker build -f Dockerfile -t swift-clion:latest .
