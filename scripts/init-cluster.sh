#!/bin/bash

. "$(dirname "$0")/functions.sh"

RED='\033[0;31m'
PLAIN='\033[0m'
ERR_TAG="[ ${RED}ERROR${PLAIN} ]"
WORKLOAD=$1
BENCHMARK=$2
INPUT_SIZE=$3
NAMESPACE=$4
YAML=$5

if [[ ! $WORKLOAD ]]; then
	echo -e "${ERR_TAG} Missing WORKLOAD parameter"
	exit 1
fi

if [[ ! $BENCHMARK ]]; then
	echo -e "${ERR_TAG} Missing BENCHMARK parameter"
	exit 1
fi

if [[ ! $INPUT_SIZE ]]; then
	echo -e "${ERR_TAG} Missing INPUT_SIZE parameter"
	exit 1
fi

if [[ ! $NAMESPACE ]]; then
	echo -e "${ERR_TAG} Missing NAMESPACE parameter"
	exit 1
fi

if [[ ! $YAML ]]; then
	echo -e "${ERR_TAG} Missing YAML parameter"
	exit 1
fi


###################
## START CLUSTER ##
###################
apply $YAML

wait_for_pod namenode 7077 $NAMESPACE
wait_for_pod namenode 50070 $NAMESPACE
wait_for_pod historyserver 10020 $NAMESPACE
wait_for_pod historyserver 10033 $NAMESPACE
wait_for_pod historyserver 10200 $NAMESPACE

################
## NETWORKING ##
################
#add_host namenode
#add_host historyserver
#add_host datanodes
#add_host resourcemanager
set_benchmark_input_size $INPUT_SIZE $NAMESPACE
# set_executor_memory "4g"
# set_executor_cores "2"

#########################
## CREATING INPUT DATA ##
#########################
prepare $WORKLOAD $BENCHMARK $NAMESPACE
