#!/bin/bash

WORKLOAD=$1
BENCHMARK=$2

# Load functions
. "$(dirname "$0")/functions.sh"

################
## BENCHMARK ##
################

bench $WORKLOAD $BENCHMARK

finish
