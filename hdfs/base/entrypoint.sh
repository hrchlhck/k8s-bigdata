#!/bin/bash

# Colors
green='\033[0;32m'
plain='\033[0m'

HADOOP_CONFIG=/etc/hadoop/

function print() {
    echo -e "${green}$1${plain}"
}

function load_config() {
    source /hadoop.env
    print "Loaded environment variables"
}

function create_config() {
    python3 /create_config.py $1 $2
    print "Created configuration file for $1"
}

load_config
create_config "CORE_CONF" ${HADOOP_CONFIG}/core-site.xml
create_config "HDFS_CONF" ${HADOOP_CONFIG}/hdfs-site.xml
create_config "YARN_CONF" ${HADOOP_CONFIG}/yarn-site.xml
create_config "MAPRED_CONF" ${HADOOP_CONFIG}/mapred-site.xml

exec "$@"