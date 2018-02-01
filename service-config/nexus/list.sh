#!/bin/bash

nexus_url=${nexus_url:-http://localhost:8081}
printf "Listing Integration API Scripts\n"

curl -v -u admin:admin123 "$nexus_url/service/siesta/rest/v1/script"
