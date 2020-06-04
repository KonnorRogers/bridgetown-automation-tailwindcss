#!/bin/bash

# A script to auto add ENV variables prior to docker-compose
source ./docker.env
docker-compose "$@"
