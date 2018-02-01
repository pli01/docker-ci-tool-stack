#!/bin/bash

name=$1
nexus_url=${nexus_url:-http://localhost:8081}

printf "Deleting Integration API Script $name\n\n"

curl -v -X DELETE -u admin:admin123  "$nexus_url/service/siesta/rest/v1/script/$name"
