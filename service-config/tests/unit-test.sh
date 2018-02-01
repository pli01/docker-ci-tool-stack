#!/bin/bash
( cd ../ansible && ansible-playbook -i config -c local -l localhost playbooks/nexus.yml --syntax-check  )
( cd ../ansible && ansible-playbook -i config -c local -l localhost playbooks/nexus.yml --list-tasks  )
