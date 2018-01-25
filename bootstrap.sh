sudo docker pull nginx
sudo docker pull sonatype/nexus3
sudo docker pull gitlab/gitlab-ce:latest
sudo docker pull jenkins/jenkins:lts

export http_proxy
export https_proxy
export no_proxy

sudo -E docker-compose up -d

