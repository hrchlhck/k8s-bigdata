FROM vpemfh7/hadoop-base:latest

LABEL MAINTAINER "Pedro Horchulhack <pedrohorchulhack@gmail.com>"

COPY --from=vpemfh7/spark-base:latest /spark /spark

# HDFS settings
ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data
RUN mkdir -p /hadoop/dfs/data
VOLUME /hadoop/dfs/data

# HDFS Datanode port
EXPOSE 9864 

ADD run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
