#!/bin/bash
set -e
echo "Service configuration started"
time ( cd $(dirname $0)/ansible &&
  ansible-playbook -i config -c local -l localhost playbooks/nexus.yml
)
echo "Service configuration finished"
