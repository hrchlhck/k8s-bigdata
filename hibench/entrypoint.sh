#!/bin/bash

# Colors
green='\033[0;32m'
plain='\033[0m'

# By default is the 'conf' on HiBench home
CONFIG_DIR=./conf

function load_config() {
    source /hdfs.env
    source /spark.env
    echo -e "${green}Loaded environment variables ${plain}"
}

function create_config() {
    python3 /create_config.py $1
    echo -e "${green}Created configuration file for $1 ${plain}"
}

load_config
create_config ${CONFIG_DIR}/hdfs.conf
create_config ${CONFIG_DIR}/spark.conf
# Make the function 'executable' in shell
export -f create_config

exec "$@"