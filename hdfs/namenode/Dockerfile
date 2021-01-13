FROM vpemfh7/hadoop-base

LABEL MAINTAINER "Pedro Horchulhack <pedrohorchulhack@gmail.com>"

# HDFS
ENV HDFS_CONF_dfs_namenode_name_dir=file:///hadoop/dfs/name
RUN mkdir -p /hadoop/dfs/name
VOLUME /hadoop/dfs/name

EXPOSE 9870 9000

# Spark
ENV SPARK_MASTER_PORT=7077
ENV SPARK_MASTER_WEBUI_PORT=8080
ENV SPARK_MASTER_LOG=/spark/logs

EXPOSE 8080 7077 6066

# HiBench
ENV HIBENCH_VERSION=7.1.1
RUN apt update && apt install zip -y \
    && wget https://github.com/Intel-bigdata/HiBench/archive/v${HIBENCH_VERSION}.zip \
    && unzip v${HIBENCH_VERSION}.zip -d /HiBench \
    && rm v${HIBENCH_VERSION}.zip \
    && mv /HiBench/ /etc/HiBench/ \
    && ln -sf /etc/HiBench/HiBench-${HIBENCH_VERSION}/ /hibench

ADD pom.xml /
RUN mkdir /scripts \
    && mv /pom.xml /hibench/sparkbench/pom.xml \
    && cd /hibench \
    && mvn -Psparkbench -Dmodules -Pmicro clean package \
    && cd /

ENV CONF=/HiBench/scripts
ENV SPARK_HOME=/spark

ADD create_hibench_config.py ${CONF}/create_hibench_config.py
ADD hadoop.env ${CONF}/hadoop.env
ADD spark.env ${CONF}/spark.env

# Execution
ADD run.sh /
RUN chmod a+x /run.sh

CMD ["/run.sh"]

