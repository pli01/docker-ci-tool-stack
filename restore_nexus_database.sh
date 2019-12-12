#!/bin/bash
# nexus restore orientdb  database 
#  only config and security
cd $HOME
java -jar ./lib/support/nexus-orient-console.jar <<'EOF'
connect plocal:../sonatype-work/nexus3/db/config admin admin
drop database
create database plocal:/nexus-data/db/config
import database /nexus-data/restore/config-export.json.gz
REBUILD INDEX *
check database
disconnect
connect plocal:../sonatype-work/nexus3/db/security admin admin
drop database
create database plocal:/nexus-data/db/security
import database /nexus-data/restore/security-export.json.gz
REBUILD INDEX *
check database
disconnect
exit
EOF


