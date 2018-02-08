#!/bin/bash
set -e
echo "Service configuration started"
time ( cd $(dirname $0)/ansible &&
  ansible-playbook -i config -c local -l localhost playbooks/site.yml -v
)
echo "Service configuration finished"
