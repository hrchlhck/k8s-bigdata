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

