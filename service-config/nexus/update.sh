#!/bin/bash

name=$1
jsonFile=$2
nexus_url=${nexus_url:-http://localhost:8081}

printf "Updating Integration API Script $name with $jsonFile\n\n"

curl -v -X PUT -u admin:admin123 --header "Content-Type: application/json" "$nexus_url/service/siesta/rest/v1/script/$name" -d @$jsonFile
