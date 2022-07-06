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

function configure_spark() {
   python3 /configure_spark.py $1 $2
   print "Added $1 to $2"
}

load_config
create_config "CORE_CONF" ${HADOOP_CONFIG}/core-site.xml
create_config "HDFS_CONF" ${HADOOP_CONFIG}/hdfs-site.xml
create_config "YARN_CONF" ${HADOOP_CONFIG}/yarn-site.xml
create_config "MAPRED_CONF" ${HADOOP_CONFIG}/mapred-site.xml

cp /spark/conf/spark-defaults.conf.template /spark/conf/spark-defaults.conf
cp /spark/conf/spark-env.sh.template /spark/conf/spark-env.sh

echo spark.executor.cores $SPARK_NUM_CORES >> /spark/conf/spark-defaults.conf
echo SPARK_WORKER_CORES=$SPARK_NUM_CORES >> /spark/conf/spark-env.sh

echo spark.executor.memory $SPARK_EXECUTOR_MEMORY >> /spark/conf/spark-defaults.conf
echo SPARK_WORKER_MEMORY=$SPARK_EXECUTOR_MEMORY >> /spark/conf/spark-env.sh

# https://github.com/big-data-europe/docker-hadoop/blob/master/base/entrypoint.sh
function wait_for_it()
{
    local serviceport=$1
    local service=${serviceport%%:*}
    local port=${serviceport#*:}
    local retry_seconds=5
    local max_try=100
    let i=1

    nc -z $service $port
    result=$?

    until [ $result -eq 0 ]; do
      echo "[$i/$max_try] check for ${service}:${port}..."
      echo "[$i/$max_try] ${service}:${port} is not available yet"
      if (( $i == $max_try )); then
        echo "[$i/$max_try] ${service}:${port} is still not available; giving up after ${max_try} tries. :/"
        exit 1
      fi
      
      echo "[$i/$max_try] try in ${retry_seconds}s once again ..."
      let "i++"
      sleep $retry_seconds

      nc -z $service $port
      result=$?
    done
    echo "[$i/$max_try] $service:${port} is available."
}

for i in ${SERVICE_PRECONDITION[@]}
do
    wait_for_it ${i}
done

exec "$@"
