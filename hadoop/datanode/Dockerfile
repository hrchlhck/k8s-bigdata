FROM vpemfh7/hadoop-base:latest

LABEL MAINTAINER "Pedro Horchulhack <pedrohorchulhack@gmail.com>"

# HDFS settings
ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data
RUN mkdir -p /hadoop/dfs/data
VOLUME /hadoop/dfs/data

# Spark worker settings
ENV SPARK_WORKER_WEBUI_PORT=8081
ENV SPARK_WORKER_LOG=/spark/logs

# HDFS Datanode port
EXPOSE 9864 

# Spark worker ports 
EXPOSE 8081 4040

ADD run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
