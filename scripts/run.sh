#!/bin/bash

WORKLOAD=$1
BENCHMARK=$2
NAMESPACE=$3

# Load functions
. "$(dirname "$0")/functions.sh"

################
## BENCHMARK ##
################

bench $WORKLOAD $BENCHMARK $NAMESPACE

finish $NAMESPACE
