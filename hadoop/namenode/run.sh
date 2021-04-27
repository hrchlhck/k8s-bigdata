#!/bin/bash

# Colors
green='\033[0;32m'
plain='\033[0m'

# By default is the 'conf' on HiBench home
CONFIG_DIR=/hibench/conf
SRC=/HiBench/scripts

function print() {
    echo -e "${green}$1${plain}"
}

function load_config() {
    source ${SRC}/hadoop.env
    source ${SRC}/spark.env
    print "Loaded environment variables"
}

function create_config() {
    python3 ${SRC}/create_hibench_config.py $1 $2
    print "Created configuration file for $1"
}

# Create configuration files for HiBench
load_config
create_config "HIBENCH" ${CONFIG_DIR}/hadoop.conf
create_config "HIBENCH" ${CONFIG_DIR}/spark.conf
create_config "SPARK" ${CONFIG_DIR}/spark.conf

set -m

# Starts namenode
$HADOOP_HOME/bin/hdfs namenode -format 
$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode &

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
