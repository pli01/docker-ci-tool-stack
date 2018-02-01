#!/bin/bash

 echo "Service configuration started"
time ( cd /opt/ansible &&
  ansible-playbook -i config -c local -l localhost playbooks/nexus.yml
)
 echo "Service configuration finished"
