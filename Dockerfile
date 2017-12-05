FROM debian:jessie

# Set environment variables
ENV DEBIAN_FRONTEND noninteractive

# Add apt repository keys, non-default sources, update apt database to load new data
# Install deps and mongodb, download unifi .deb, install and remove package
# Cleanup after apt to minimize image size
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 && \
  echo "deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen" \
    | tee -a /etc/apt/sources.list.d/mongodb.list && \
  apt-get update -q && \
  apt-get -y install \
    binutils \
    wget \
    openjdk-8-jre-headless \
    jsvc \
    mongodb-org-server && \
  wget -nv https://dl.ubnt.com/unifi/5.7.8-5204056bce/unifi_sysvinit_all.deb && \
  dpkg --install unifi_sysvinit_all.deb && \
  rm unifi_sysvinit_all.deb && \
  apt-get -y autoremove wget && \
  apt-get -q clean && \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /tmp/* /var/tmp/*

# Forward apporpriate ports
EXPOSE 8080/tcp 8443/tcp 8843/tcp 8880/tcp 3478/udp

# Set internal storage volume
VOLUME ["/usr/lib/unifi/data", "/usr/lib/unifi/logs", "/var/log/supervisor"]

# Set working directory for program
WORKDIR /usr/lib/unifi
