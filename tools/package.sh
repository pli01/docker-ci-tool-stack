#!/bin/bash

SERVICE_BUILD_DIR=$(docker-compose config --services)

BUILDROOT=$(pwd)/dist
[ -d $BUILDROOT ] && rm -rf $BUILDROOT
mkdir -p $BUILDROOT

tar zc  \
      docker-compose.yml \
      $SERVICE_BUILD_DIR \
    | \
  (cd $BUILDROOT && tar zxvf -  )

#rm -rf $BUILDROOT
exit 0

