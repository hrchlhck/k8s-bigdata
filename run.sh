#!/bin/bash

# Responsible for executing commands inside a given pod and container
function podexec () {
	local pod=$1
	local container=$2
	local cmd=$3
	kubectl exec -it $pod -c $container -- $cmd
}

# Prepares the workload. In other words, it creates data and copy to HDFS to be used later.
function prepare() {
	local benchmark=$1
	podexec namenode namenode "hibench/bin/workloads/micro/$1/prepare/prepare.sh"
}

# Saves the HiBench report files into the host
function save_bench_files() {
	podexec namenode namenode "cat /hibench/report/hibench.report" > ./hibench.report
}

# Does the benchmark. Can specify N benchmarks to be executed inside namenode pod.
# To see the benchmarks refer to https://github.com/Intel-bigdata/HiBench
function bench() {
	for _bench in $@; do
		prepare $_bench
		podexec namenode namenode "hibench/bin/workloads/micro/$_bench/spark/run.sh"
	done
}

# WIP solution. Refer to issue #4 on https://github.com/hrchlhck/k8s-bigdata
DATANODE=`kubectl get pods --no-headers --selector=app=datanode --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'`
DATANODE_IP=`kubectl get pods $DATANODE --template={{.status.podIP}}`
# podexec resourcemanager resourcemanager "echo $DATANODE_IP $DATANODE >> /etc/hosts"
# podexec resourcemanager resourcemanager 'cat /etc/hosts'

bench $@
save_bench_files
