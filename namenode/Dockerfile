FROM vpemfh7/hadoop-base:latest

LABEL MAINTAINER "Pedro Horchulhack <pedrohorchulhack@gmail.com>"

RUN mkdir -p /hadoop/dfs/name

ENV HDFS_CONF_dfs_namenode_dir=file:///hadoop/dfs/name 

VOLUME /hadoop/dfs/name

ADD run.sh /run.sh

RUN chmod a+x /run.sh

EXPOSE 9870 9000

# HiBench setup
ENV HIBENCH_VERSION=7.1.1

RUN apt install -y maven unzip

RUN wget https://github.com/Intel-bigdata/HiBench/archive/v${HIBENCH_VERSION}.zip
RUN unzip v${HIBENCH_VERSION}.zip -d ./HiBench
RUN rm v${HIBENCH_VERSION}.zip 

WORKDIR /HiBench/HiBench-${HIBENCH_VERSION}

CMD ["/run.sh"]
