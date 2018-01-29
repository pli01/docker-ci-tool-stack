#!/bin/bash

name=$1
nexus=${nexus:-http://localhost:8081}

printf "Deleting Integration API Script $name\n\n"

curl -v -X DELETE -u admin:admin123  "$nexus/service/siesta/rest/v1/script/$name"
