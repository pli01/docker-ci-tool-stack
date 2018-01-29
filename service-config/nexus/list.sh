#!/bin/bash

nexus=${nexus:-http://localhost:8081}
printf "Listing Integration API Scripts\n"

curl -v -u admin:admin123 "$nexus/service/siesta/rest/v1/script"
