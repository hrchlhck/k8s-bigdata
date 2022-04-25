FROM vpemfh7/hadoop-base

LABEL MAINTAINER "Pedro Horchulhack <pedrohorchulhack@gmail.com>"

COPY --from=vpemfh7/spark-base:latest /spark /spark

# HDFS
ENV HDFS_CONF_dfs_namenode_name_dir=file:///hadoop/dfs/name
RUN mkdir -p /hadoop/dfs/name
VOLUME /hadoop/dfs/name

# Execution
ADD run.sh /
RUN chmod a+x /run.sh

EXPOSE 9870 9000 8080 7077 6066

CMD ["/run.sh"]

