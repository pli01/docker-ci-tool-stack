FROM debian:latest
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -q update && \
    apt-get install -qy --no-install-recommends --force-yes \
    curl jq ansible python-apt && \
    apt-get autoremove -y && apt-get autoclean -y &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# nexus
ADD nexus /opt/nexus
ADD nexus-config /opt/nexus-config
COPY nexus-config.sh /opt/
ADD ansible /opt/ansible
COPY run.sh /opt/run.sh

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENV nexus_url http://localhost:8081/nexus

ENTRYPOINT ["/docker-entrypoint.sh"]
