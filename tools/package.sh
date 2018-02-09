#!/bin/bash

SERVICE_BUILD_DIR=$(docker-compose config --services)

find \
      docker-compose.yml \
      $SERVICE_BUILD_DIR \
    -type f ! -regex ".*.git"
