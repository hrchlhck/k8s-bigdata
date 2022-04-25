FROM debian:9

RUN apt update -y \
    && apt install -y \
    libsnappy-dev gnupg maven python python3 wget libc6 netcat procps curl openjdk-8-jdk

ENV CONF=/HiBench/scripts
ENV HIBENCH_VERSION=7.1.1
RUN apt update && apt install -y zip bc \
    && wget https://github.com/Intel-bigdata/HiBench/archive/v${HIBENCH_VERSION}.zip \
    && unzip v${HIBENCH_VERSION}.zip -d /HiBench \
    && rm v${HIBENCH_VERSION}.zip \
    && mv /HiBench/ /etc/HiBench/ \
    && ln -sf /etc/HiBench/HiBench-${HIBENCH_VERSION}/ /hibench

RUN mkdir /scripts \
    && cd /hibench \
    && mvn -Psparkbench -Dmodules -Pmicro -Pml -Pwebsearch clean package \
    && cd /

ADD create_hibench_config.py ${CONF}/create_hibench_config.py
ADD hadoop.env ${CONF}/hadoop.env
ADD spark.env ${CONF}/spark.env

COPY hibench_conf/sort.conf /hibench/conf/workloads/micro/sort.conf
COPY hibench_conf/terasort.conf /hibench/conf/workloads/micro/terasort.conf
COPY hibench_conf/wordcount.conf /hibench/conf/workloads/micro/wordcount.conf
COPY hibench_conf/pagerank.conf /hibench/conf/workloads/websearch/pagerank.conf
COPY hibench_conf/rf.conf /hibench/conf/workloads/ml/rf.conf

# Execution
ADD run.sh /
RUN chmod a+x /run.sh