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
	local module=$1
	local benchmark=$2
	podexec namenode namenode "hibench/bin/workloads/$module/$benchmark/prepare/prepare.sh"
}

# Saves the HiBench report files into the host
function save_bench_files() {
	podexec namenode namenode "cat /hibench/report/hibench.report" > ./hibench.report
}

# Does the benchmark. Can specify N benchmarks to be executed inside namenode pod.
# To see the benchmarks refer to https://github.com/Intel-bigdata/HiBench
function bench() {
	local module=$1
	local benchmark=$2
	local command="hibench/bin/workloads/$module/$benchmark/spark/run.sh"

	prepare $module $benchmark

	if [[ "$benchmark" == "dfsioe" ]]; then
		# Substitution of text based in a pattern
		podexec namenode namenode ${command/spark/hadoop}
	else
		podexec namenode namenode $command
	fi
}

# Check if the pod /etc/hosts file has a host
function has_host() {
	local host=$1
	local pod=$2
	local container=$3
	
	if [[ $container ]]; then
		# Return true if a container inside a pod has host $host 
		echo "Executing for pod that has multiple containers"
		if [[ $(podexec $pod $container 'cat /etc/hosts' | grep $host) ]]; then
			return 1	
		else
			return 0
		fi
	else
		# Return true if the only container in the pod has host $host
		echo "Executing for single container pod"
		if [[ $(podexec $pod $pod  'cat /etc/hosts' | grep $host) ]]; then
			return 1
		else
			return 0
		fi
	fi	

}

# This section is supposed to add all datanodes names to /etc/hosts of resourcemanager pod.
# WIP solution. Refer to issue #4 on https://github.com/hrchlhck/k8s-bigdata
function add_host() {
	local pod_name=$1
	local datanodes=($(kubectl get pods -o wide --no-headers | awk '{if ($1 ~ /datanode/) {print ($1","$6)};}'))

	for datanode in "${datanodes[@]}"; do
		name=$(echo $datanode | awk '{split($1, a, ","); print a[1]}')
		ip=$(echo $datanode | awk '{split($1, a, ","); print a[2]}')

		
		if [[ $pod_name == "datanodes" ]]; then
			for _datanode in "${datanodes[@]}"; do
				_name=$(echo $_datanode | awk '{split($1, a, ","); print a[1]}')
				if [[ ! `has_host $name $_name nodemanager` || ! `has_host $name $_name datanode` ]]; then
					echo "Adding $ip $name to $_name"
					kubectl exec -it $_name -c datanode -- /bin/bash -c "echo -e ${ip} ${name} >> /etc/hosts"
					kubectl exec -it $_name -c nodemanager -- /bin/bash -c "echo -e ${ip} ${name} >> /etc/hosts"
				else
					echo "$_name already contains $ip $name"
				fi
			done
		else
			if [[ ! `has_host $name $pod_name` ]]; then
				echo "Adding $ip $name to $pod_name"
				kubectl exec -it $pod_name -- /bin/bash -c "echo -e ${ip} ${name} >> /etc/hosts"
			else
				echo "$pod_name already contains $ip $name"
			fi
		fi
	done
}

add_host resourcemanager
add_host namenode
add_host historyserver
add_host datanodes


bench micro wordcount
# bench micro terasort
# bench micro dfsioe
# bench websearch pagerank
save_bench_files
