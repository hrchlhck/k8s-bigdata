FROM bde2020/hadoop-base:2.0.0-hadoop3.2.1-java8

LABEL MAINTAINER "Pedro Horchulhack <pedrohorchulhack@gmail.com>"

ENV HDFS_CONF_dfs_namenode_name_dir=file:///hadoop/dfs/name
RUN mkdir -p /hadoop/dfs/name
VOLUME /hadoop/dfs/name

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 9870 9000

CMD ["/run.sh"]
