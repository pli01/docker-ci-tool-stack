#!/bin/bash
# nexus backup: export orientdb  database 
#  only config and security
[ -d "/nexus-data/backup/" ] || mkdir -p "/nexus-data/backup/"
cd $HOME
java -jar ./lib/support/nexus-orient-console.jar <<'EOF'
connect plocal:../sonatype-work/nexus3/db/config admin admin
REBUILD INDEX *
REPAIR DATABASE --fix-graph
REPAIR DATABASE --fix-links
REPAIR DATABASE --fix-ridbags
REPAIR DATABASE --fix-bonsai
check database
export database /nexus-data/backup/config-export
disconnect
connect plocal:../sonatype-work/nexus3/db/security admin admin
REBUILD INDEX *
REPAIR DATABASE --fix-graph
REPAIR DATABASE --fix-links
REPAIR DATABASE --fix-ridbags
REPAIR DATABASE --fix-bonsai
check database
export database /nexus-data/backup/security-export
disconnect
exit
EOF


