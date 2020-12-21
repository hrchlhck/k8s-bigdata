FROM debian:9 

LABEL MAINTAINER "Pedro Horchulhack <pedrohorchulhack@gmail.com>"

# Installing dependencies
RUN apt-get update -y && \
    apt install -y openjdk-8-jdk \
            curl \
            net-tools \
            vim \
            libsnappy-dev \ 
    && apt install -y bash perl vim wget
 
# Basic environtment variables
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV HADOOP_VERSION=3.2.1

# Retrieving hadoop from server
RUN wget https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz

# Unpacking and setting up the files
RUN tar -xvzf hadoop-${HADOOP_VERSION}.tar.gz
RUN rm -rf hadoop-${HADOOP_VERSION}.tar.gz && mv hadoop-${HADOOP_VERSION} /opt/

# Creating an alias to /etc/hadoop
RUN ln -s /opt/hadoop-${HADOOP_VERSION}/etc/hadoop /etc/hadoop

RUN mkdir /opt/hadoop-${HADOOP_VERSION}/logs

# More env variables
ENV HADOOP_HOME=/opt/hadoop-${HADOOP_VERSION}
ENV USER=root
ENV PATH ${HADOOP_HOME}/bin/:$PATH

# Adding entrypoint
ADD entrypoint.sh /entrypoint.sh
RUN chmod a+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
