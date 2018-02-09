FROM debian:latest
# Build
ARG MIRROR_DEBIAN
ARG APP_ENV=dev
# Run
ENV DEBIAN_FRONTEND noninteractive
ENV SERVICE_CONFIG_NEXUS_ENABLE true
ENV SERVICE_CONFIG_GITLAB_ENABLE true
ENV SERVICE_CONFIG_JENKINS_ENABLE true

# Use nexus repo to speed up build if MIRROR_DEBIAN defined
RUN echo "$APP_ENV $http_proxy $no_proxy" && set -x && [ -z "$MIRROR_DEBIAN" ] || \
     sed -i.orig -e "s|http://deb.debian.org/debian|$MIRROR_DEBIAN/debian9|g ; s|http://security.debian.org|$MIRROR_DEBIAN/debian9-security|g" /etc/apt/sources.list

RUN apt-get -q update && \
    apt-get install -qy --no-install-recommends --force-yes \
    curl jq ansible python-apt \
      git  && \
    apt-get autoremove -y && apt-get autoclean -y &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# config / playbook / roles
ADD ansible /opt/ansible
COPY ${APP_ENV}.config /opt/ansible/config/group_vars/all
COPY run.sh /opt/run.sh
COPY build.sh /opt/build.sh
RUN chmod +x /opt/build.sh && bash /opt/build.sh && rm -rf /opt/build.sh

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENV nexus_url http://localhost:8081/nexus

ENTRYPOINT ["/docker-entrypoint.sh"]
