FROM vpemfh7/hadoop2.6-base

LABEL MAINTAINER "Pedro Horchulhack <pedrohorchulhack@gmail.com>"

ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data
RUN mkdir -p /hadoop/dfs/data
VOLUME /hadoop/dfs/data

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 9864

CMD ["/run.sh"]
