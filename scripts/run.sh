#!/bin/bash

WORKLOAD=$1
BENCHMARK=$2

# Load functions
. functions.sh

################
## BENCHMARK ##
################

bench $WORKLOAD $BENCHMARK

finish
