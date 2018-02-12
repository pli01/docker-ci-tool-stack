FROM jenkins/jenkins:lts
# Docker versions Env Variables
ENV DOCKER_ENGINE_VERSION=latest
ENV DOCKER_COMPOSE_VERSION=1.19.0

# Env Variables
ARG MIRROR_DEBIAN
ARG APP_ENV=dev

# Package custom
ARG PACKAGE_CUSTOM="ruby make ansible git unzip python-pip python-dev python-openstackclient python-heatclient jenkins-job-builder"
ENV PACKAGE_CUSTOM=$PACKAGE_CUSTOM

USER root
# Use nexus repo to speed up build if MIRROR_DEBIAN defined
RUN echo "$APP_ENV $http_proxy $no_proxy" && set -x && [ -z "$MIRROR_DEBIAN" ] || \
     sed -i.orig -e "s|http://deb.debian.org/debian|$MIRROR_DEBIAN/debian9|g ; s|http://security.debian.org|$MIRROR_DEBIAN/debian9-security|g" /etc/apt/sources.list

# Customize jenkins at startup
# install package requirements
RUN apt-get -q update \
      && apt-get install -qy --no-install-recommends sudo curl \
        $PACKAGE_CUSTOM \
      && apt-get install -qy libltdl7 \
      && rm -rf /var/lib/apt/lists/*
RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

# getting the docker-cli
# --- Attention: docker.sock needs to be mounted as volume in docker-compose.yml
# see: https://issues.jenkins-ci.org/browse/JENKINS-35025
# see: https://get.docker.com/builds/
# see: https://wiki.jenkins-ci.org/display/JENKINS/CloudBees+Docker+Custom+Build+Environment+Plugin#CloudBeesDockerCustomBuildEnvironmentPlugin-DockerinDocker
RUN curl -sSL -o /bin/docker https://get.docker.io/builds/Linux/x86_64/docker-latest && \
    chmod +x /bin/docker
RUN curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

USER jenkins

# installing specific list of plugins. see: https://github.com/jenkinsci/docker#preinstalling-plugins
ARG JENKINS_UC_URL
ENV JENKINS_UC=$JENKINS_UC_URL

COPY plugins.txt.latest /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/plugins.txt

# Adding default Jenkins Seed Job
COPY jobs/job-dsl-seed-job.xml /usr/share/jenkins/ref/jobs/job-dsl-seed-job/config.xml

############################################
# Configure Jenkins
############################################
# Jenkins settings
COPY config/config.xml /usr/share/jenkins/ref/config.xml

# Jenkins Settings, i.e. Maven, Groovy, ...
COPY config/hudson.tasks.Maven.xml /usr/share/jenkins/ref/hudson.tasks.Maven.xml
COPY config/hudson.plugins.groovy.Groovy.xml /usr/share/jenkins/ref/hudson.plugins.groovy.Groovy.xml
COPY config/maven-global-settings-files.xml /usr/share/jenkins/ref/org.jenkinsci.plugins.configfiles.GlobalConfigFiles.xml

# SSH Keys & Credentials
COPY config/credentials.xml /usr/share/jenkins/ref/credentials.xml
COPY config/ssh-keys/cd-demo /usr/share/jenkins/ref/.ssh/id_rsa
COPY config/ssh-keys/cd-demo.pub /usr/share/jenkins/ref/.ssh/id_rsa.pub

# tell Jenkins that no banner prompt for pipeline plugins is needed
# see: https://github.com/jenkinsci/docker#preinstalling-plugins
RUN echo 2.0 > /usr/share/jenkins/ref/jenkins.install.UpgradeWizard.state

USER jenkins
# Jenkins Default Config
# JENKINS_SECURITY_REALM= none jenkins ldap pam
ENV JENKINS_SECURITY_REALM=""
# JENKINS_AUTHORIZATION_STRATEGY=full role
ENV JENKINS_AUTHORIZATION_STRATEGY=full
ENV JENKINS_AUTHZ_JSON_URL=""
ENV JENKINS_GROUP_NAME_ADMIN=""
# LDAP
ENV LDAP_INHIBIT_INFER_ROOTDN=""
ENV LDAP_DISABLE_MAIL_ADDRESS_RESOLVER=""

# install pip requirements
#COPY requirements.txt /usr/share/jenkins/requirements.txt
#RUN pip install -r /usr/share/jenkins/requirements.txt

RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/

# Enable pam authent: jenkins user need to read shadow
USER root
RUN adduser jenkins shadow

USER jenkins
