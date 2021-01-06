FROM vpemfh7/hadoop-base

LABEL MAINTAINER "Pedro Horchulhack <pedrohorchulhack@gmail.com>"

ENV HDFS_CONF_dfs_namenode_name_dir=file:///hadoop/dfs/name
RUN mkdir -p /hadoop/dfs/name
VOLUME /hadoop/dfs/name

EXPOSE 9870 9000

ADD run.sh /
RUN chmod a+x /run.sh

CMD ["/run.sh"]

