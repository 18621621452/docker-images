#upstream https://github.com/sheepkiller/kafka-manager-docker
FROM centos:7

MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

COPY epel.repo /etc/yum.repos.d/
COPY java.sh /etc/profile.d/

# set timezone
RUN ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

RUN \
    yum update -y && \
    yum install -y wget && \
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u161-b12/2f38c3b165be4555a1fa6e98c45e0808/jdk-8u161-linux-x64.rpm && \
    rpm -ivh jdk-8u161-linux-x64.rpm && \
    rm jdk-8u161-linux-x64.rpm

ENV JAVA_HOME=/usr/java/jdk1.8.0_161 \
    ZK_HOSTS=localhost:2181 \
    KM_VERSION=1.3.1.8 \
    KM_REVISION=97329cc8bf462723232ee73dc6702c064b5908eb \
    KM_CONFIGFILE="conf/application.conf"

ADD start-kafka-manager.sh /kafka-manager-${KM_VERSION}/start-kafka-manager.sh

RUN yum install -y git wget unzip which && \
    mkdir -p /tmp && \
    cd /tmp && \
    git clone https://github.com/yahoo/kafka-manager && \
    cd /tmp/kafka-manager && \
    git checkout ${KM_REVISION} && \
    echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && \
    ./sbt clean dist && \
    unzip  -d / ./target/universal/kafka-manager-${KM_VERSION}.zip && \
    rm -fr /tmp/* /root/.sbt /root/.ivy2 && \
    chmod +x /kafka-manager-${KM_VERSION}/start-kafka-manager.sh && \
    yum autoremove -y git wget unzip which && \
    yum clean all

WORKDIR /kafka-manager-${KM_VERSION}

EXPOSE 9000
ENTRYPOINT ["./start-kafka-manager.sh"]
