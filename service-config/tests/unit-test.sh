#!/bin/bash
( cd ../ansible && ansible-playbook -i config -c local -l localhost playbooks/site.yml --syntax-check  )
( cd ../ansible && ansible-playbook -i config -c local -l localhost playbooks/site.yml --list-tasks  )
