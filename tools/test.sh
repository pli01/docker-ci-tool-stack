#!/bin/bash
set -e
echo "Test docker-compose file"

ret=0

BUILDROOT=$(pwd)/dist
[ -d $BUILDROOT ] || exit 1
#
echo "BUILDROOT: $BUILDROOT"
echo "compose_args: $compose_args"
echo "http_proxy: $http_proxy"
echo "https_proxy: $https_proxy"
echo "no_proxy: $no_proxy"

cd $BUILDROOT

echo "docker-compose: list services"
docker-compose $compose_args config --services
echo "docker-compose: config syntax"
docker-compose $compose_args config

exit $ret
