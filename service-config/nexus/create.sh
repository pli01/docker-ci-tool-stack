#!/bin/bash

jsonFile=$1
nexus=${nexus:-http://localhost:8081}

printf "Creating Integration API Script from $jsonFile\n\n"

curl -v -u admin:admin123 --header "Content-Type: application/json" "$nexus/service/siesta/rest/v1/script/" -d @$jsonFile
