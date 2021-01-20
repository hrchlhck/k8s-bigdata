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

# This section is supposed to add all datanodes names to /etc/hosts of resourcemanager pod.
# WIP solution. Refer to issue #4 on https://github.com/hrchlhck/k8s-bigdata
DATANODES=($(kubectl get pods -o wide --no-headers | awk '{if ($1 ~ /datanode/) {print ($1","$6)};}'))
for datanode in "${DATANODES[@]}"; do
	name=$(echo $datanode | awk '{split($1, a, ","); print a[1]}')
	ip=$(echo $datanode | awk '{split($1, a, ","); print a[2]}')
	kubectl exec -it resourcemanager -- /bin/bash -c "echo -e ${name} ${ip} >> /etc/hosts"
done

podexec resourcemanager resourcemanager 'cat /etc/hosts'

bench $@
save_bench_files
