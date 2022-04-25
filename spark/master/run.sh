#!/bin/bash

# Starts Spark master
export SPARK_DIST_CLASSPATH=$(hadoop --config $HADOOP_CONF_DIR  classpath)
export SPARK_HOME=/spark
export SPARK_MASTER_HOST=`hostname`

. "/spark/sbin/spark-config.sh"

. "/spark/bin/load-spark-env.sh"

mkdir -p $SPARK_MASTER_LOG

ln -sf /dev/stdout $SPARK_MASTER_LOG/spark-master.out

cd /spark/bin && /spark/sbin/../bin/spark-class org.apache.spark.deploy.master.Master \
	--host $SPARK_MASTER_HOST --webui-port $SPARK_MASTER_WEBUI_PORT --properties-file /spark/conf/spark-defaults.conf >> $SPARK_MASTER_LOG/spark-master.out
