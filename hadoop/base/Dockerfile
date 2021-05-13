FROM debian:9

# Dependencies
RUN apt update && apt install -y \
      openjdk-8-jdk \
      net-tools \
      curl \
      gnupg \
      libsnappy-dev \
      maven \
      python \
      python3 \ 
      wget \
      libc6 \
      netcat \
      procps \
    && rm -rf /var/lib/apt/lists/*
      
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

# HDFS
RUN curl -O https://dist.apache.org/repos/dist/release/hadoop/common/KEYS && gpg --import KEYS

ENV HADOOP_VERSION=2.7.0
ENV HADOOP_URL=https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz

RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && curl -fSL "$HADOOP_URL.asc" -o /tmp/hadoop.tar.gz.asc \
    && gpg --verify /tmp/hadoop.tar.gz.asc \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz*

RUN ln -s /opt/hadoop-${HADOOP_VERSION}/etc/hadoop /etc/hadoop

RUN mkdir /opt/hadoop-${HADOOP_VERSION}/logs

RUN mkdir /hadoop-data

ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV USER=root
ENV PATH $HADOOP_HOME/bin/:$PATH

ADD entrypoint.sh /
ADD create_config.py /
ADD hadoop.env /
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
