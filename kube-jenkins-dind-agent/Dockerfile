#upstream https://github.com/jenkinsci/docker-jnlp-slave
FROM debian:stretch
MAINTAINER 若虚 <slpcat@qq.com>

ENV \
    TERM=xterm \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    TIMEZONE=Asia/Shanghai \
    #openjdk8
    #JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    #DOCKER_EXTRA_OPTS="--insecure-registry=gitlab.default.svc.cluster.local:5000" \
    SSH_KNOWN_HOSTS=github.com

RUN echo 'deb http://mirrors.aliyun.com/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list \
    && sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/mirrors.aliyun.com\/debian-security/' /etc/apt/sources.list

# Set timezone and locales
RUN \
    echo "${TIMEZONE}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog vim-tiny locales \ 
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

#openjdk8 apt-get install -y openjdk-8-jdk-headless
# Add Oracle Java PPA
RUN \
    apt-get -y update && \
    apt-get -y install software-properties-common apt-transport-https gnupg2 ca-certificates && \
    add-apt-repository -y ppa:webupd8team/java && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
    apt-get -y update && \
    # Auto-accept the Oracle License
    #echo "debconf shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    #echo "debconf shared/accepted-oracle-license-v1-1 seen true" | debconf-set-selections && \
    echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get -y install libpq-dev oracle-java8-installer && \
    # Clean up
    rm -f /var/cache/oracle-jdk8-installer/jdk-*.tar.g

RUN apt-get update -y       \
    && apt-get upgrade -y   \
    && apt-get install -y   \
       build-essential      \
       bzip2                \
       curl                 \
       sudo                 \
       git                  \
       iptables             \
       jq                   \
       maven                \
       unzip                \
       zip                  

#Install Docker in Docker
RUN \
   curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg |apt-key add - \
   && add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable" \
   && apt-get update -y \
   && apt-get install -y docker-ce

COPY daemon.json /etc/docker/daemon.json

# jenkins slave
ENV HOME /home/jenkins

RUN groupadd -g 10000 jenkins \
    && useradd -c "Jenkins user" -d $HOME -u 10000 -g 10000 -m jenkins \
    && usermod -a -G docker jenkins \
    && sed -i '/^root/a\jenkins    ALL=(ALL:ALL) NOPASSWD:ALL' /etc/sudoers

LABEL Description="This is a base image, which provides the Jenkins agent executable (slave.jar)" Vendor="Jenkins project" Version="3.15"

ARG VERSION=3.15
ARG AGENT_WORKDIR=/home/jenkins/agent

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

COPY jenkins-slave /usr/local/bin/jenkins-slave
USER jenkins

ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/jenkins/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/jenkins/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/jenkins

ENTRYPOINT ["jenkins-slave"]
