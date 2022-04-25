FROM debian:9

RUN apt update \
    && apt install -y \
    openjdk-8-jdk \
    libc6 \
    python3 \
    python \
    libsnappy-dev \
    curl \
    wget \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

# Apache Spark
ENV SPARK_VERSION=2.4.7
ENV HADOOP_VERSION=2.7
ENV PYTHONHASHSEED=1

ENV SPARK_FILE=spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}
RUN wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/${SPARK_FILE}.tgz \
    && tar -xvzf ${SPARK_FILE}.tgz \
    && mv ${SPARK_FILE} spark \
    && rm ${SPARK_FILE}.tgz \
    && cd /

# Spark
ENV SPARK_MASTER_PORT=7077
ENV SPARK_MASTER_WEBUI_PORT=8080
ENV SPARK_MASTER_LOG=/spark/logs
ENV SPARK_HOME=/spark

RUN cp /spark/conf/spark-defaults.conf.template /spark/conf/spark-defaults.conf
RUN cp /spark/conf/spark-env.sh.template /spark/conf/spark-env.sh