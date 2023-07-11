FROM vpemfh7/hadoop-base

LABEL MAINTAINER "Pedro Horchulhack <pedrohorchulhack@gmail.com>"

COPY --from=vpemfh7/spark-base:latest /spark /spark

# HDFS
ENV HDFS_CONF_dfs_namenode_name_dir=file:///hadoop/dfs/name
RUN mkdir -p /hadoop/dfs/name
VOLUME /hadoop/dfs/name

# Spark
ENV SPARK_MASTER_PORT=7077
ENV SPARK_MASTER_WEBUI_PORT=8080
ENV SPARK_MASTER_LOG=/spark/logs
ENV SPARK_HOME=/spark

# HiBench
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

COPY hibench_conf/hibench_prop_env_mapping.py /hibench/bin/functions/hibench_prop_env_mapping.py
COPY hibench_conf/sort.conf /hibench/conf/workloads/micro/sort.conf
COPY hibench_conf/terasort.conf /hibench/conf/workloads/micro/terasort.conf
COPY hibench_conf/wordcount.conf /hibench/conf/workloads/micro/wordcount.conf
COPY hibench_conf/pagerank.conf /hibench/conf/workloads/websearch/pagerank.conf
COPY hibench_conf/rf.conf /hibench/conf/workloads/ml/rf.conf
COPY hibench_conf/svm.conf /hibench/conf/workloads/ml/svm.conf

# Execution
ADD run.sh /
RUN chmod a+x /run.sh

EXPOSE 9870 9000 8080 7077 6066

CMD ["/run.sh"]

