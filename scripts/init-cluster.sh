#!/bin/bash

. "$(dirname "$0")/functions.sh"

WORKLOAD=$1
BENCHMARK=$2
INPUT_SIZE=$3

###################
## START CLUSTER ##
###################
apply kubernetes/cluster.yml

wait_pods

################
## NETWORKING ##
################
add_host resourcemanager
add_host namenode
add_host historyserver
add_host datanodes
set_benchmark_input_size $INPUT_SIZE

#########################
## CREATING INPUT DATA ##
#########################
prepare $WORKLOAD $BENCHMARK
