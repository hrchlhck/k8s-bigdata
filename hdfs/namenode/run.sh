#!/bin/bash

$HADOOP_HOME/bin/hdfs namenode -format
$HADOOP_HOME/bin/hdfs --config $HADOOP_CONF_DIR namenode
