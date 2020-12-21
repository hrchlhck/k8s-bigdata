FROM vpemfh7/hadoop-base:latest

LABEL MAINTAINER "Pedro Horchulhack <pedrohorchulhack@gmail.com>"

RUN mkdir -p /hadoop/dfs/data

ENV HDFS_CONF_dfs_datanode_dir=file:///hadoop/dfs/data
VOLUME /hadoop/dfs/data

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 9864

CMD ["/run.sh"]
