#!/bin/bash

# Colors
green='\033[0;32m'
plain='\033[0m'

# By default is the 'conf' on HiBench home
CONFIG_DIR=./conf

function print() {
    echo -e "${green}$1${plain}"
}

function load_config() {
    source /hadoop.env
    source /spark.env
    print "Loaded environment variables"
}

function create_config() {
    python3 /create_config.py $1 $2
    print "Created configuration file for $1"
}

load_config
create_config "HIBENCH" ${CONFIG_DIR}/hadoop.conf
create_config "HIBENCH" ${CONFIG_DIR}/spark.conf
create_config "SPARK" ${CONFIG_DIR}/spark.conf

exec "$@"
