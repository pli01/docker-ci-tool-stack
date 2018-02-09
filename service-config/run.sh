#!/bin/bash
set -e

# Activate configuration playbook of following services
SERVICE_CONFIG_NEXUS_ENABLE=${SERVICE_CONFIG_NEXUS_ENABLE:-true}
SERVICE_CONFIG_GITLAB_ENABLE=${SERVICE_CONFIG_GITLAB_ENABLE:-true}
SERVICE_CONFIG_JENKINS_ENABLE=${SERVICE_CONFIG_JENKINS_ENABLE:-true}

echo "Service configuration started"
time ( cd $(dirname $0)/ansible &&
  ansible-playbook -i config -c local -l localhost \
     -e 'service_config_nexus_enable=${SERVICE_CONFIG_NEXUS_ENABLE}' \
     -e 'service_config_gitlab_enable=${SERVICE_CONFIG_GITLAB_ENABLE}' \
     -e 'service_config_jenkins_enable=${SERVICE_CONFIG_JENKINS_ENABLE}' \
     playbooks/site.yml -v
)
echo "Service configuration finished (status: $?)"
