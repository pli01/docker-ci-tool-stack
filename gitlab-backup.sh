#!/bin/bash
set -e
export LC_ALL=C
export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
rootdir=$HOME
workdir=$rootdir/ci-tool-stack/docker-ci-tool-stack

source $rootdir/proxy.sh
source $rootdir/creds.sh
cd $workdir || exit 1
id
pwd
sudo find /opt/gitlab/data/backups/ -regex ".*.tar" -exec rm {} \; || true
make env=forge-mi backup | tee /tmp/backup.out
if [ -d backups ] ; then rm -rf backups ; fi
exit 0
