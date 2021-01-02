
if [ -z $CLUSTER_NAME ]; then
    echo "Must specify a name for the cluster"
    exit 0
fi	


cat /etc/hadoop/core-site.xml

# $HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR 
$HADOOP_HOME/bin/hdfs namenode -format $CLUSTER_NAME
$HADOOP_HOME/bin/hdfs namenode
