#!/bin/bash

NAMESPACE=k8s-bigdata

# Responsible for executing commands inside a given pod and container
function podexec () {
	local pod=$1
	local container=$2
    local cmd=$3

	kubectl exec -it $pod -c $container -n $NAMESPACE -- $cmd
}

# Wrapper function for `kubectl apply`
function apply() {
    local yaml_path=$1
    kubectl apply -f $yaml_path
}

# Prepares the workload. In other words, it creates data and copy to HDFS to be used later.
function prepare() {
	local module=$1
	local benchmark=$2
	podexec namenode namenode "hibench/bin/workloads/$module/$benchmark/prepare/prepare.sh"
}

# Check if the pod /etc/hosts file has a host
function has_host() {
	local host=$1
	local pod=$2
	local container=$3
	local ret=0
	if [[ $container ]]; then
		# Return true if a container inside a pod has host $host 
		if [[ $(podexec $pod $container 'cat /etc/hosts' | grep $host) ]]; then
			ret=1	
		fi
	else
		# Return true if the only container in the pod has host $host
		if [[ $(podexec $pod $pod  'cat /etc/hosts' | grep $host) ]]; then
			ret=1
		fi
	fi
	return "$ret"

}

# Change hibench.conf inside 'namenode' pod with the desired workload size. 
# Supported workload sizes:
#     - tiny
#     - small
#     - large
#     - huge
#     - gigantic
#     - bigdata
function set_benchmark_input_size() {
	local size=$1
	kubectl exec -it namenode -n $NAMESPACE -- sed -i "s/hibench.scale.profile.*/hibench.scale.profile $size/" /hibench/conf/hibench.conf
}

# Function to set total memory of each executor on the spark cluster. Default number of executors is 2, so
# the memory set is always N * 2 for each node.
function set_executor_memory() {
        local memory=$1
        kubectl exec -it namenode -n k8s-bigdata -- /bin/bash -c "echo spark.executor.memory $memory >> /hibench/conf/spark.conf"
}

# Function to set the total number of executor cores of the cluster
function set_executor_cores {
	local cores=$1
	kubectl exec -it namenode -n k8s-bigdata -- /bin/bash -c "echo spark.executor.cores $cores >> /hibench/conf/spark.conf"
}

# Saves the HiBench report files into the host
function save_bench_files() {
	podexec namenode namenode "tail -n1 /hibench/report/hibench.report" >> ./hibench.report
}

# Does the benchmark. Can specify N benchmarks to be executed inside namenode pod.
# To see the benchmarks refer to https://github.com/Intel-bigdata/HiBench
function bench() {
	local module=$1
	local benchmark=$2
	local command="hibench/bin/workloads/$module/$benchmark/spark/run.sh"

	if [[ "$benchmark" == "dfsioe" ]]; then
		# Substitution of text based in a pattern
		podexec namenode namenode ${command/spark/hadoop}
	else
		podexec namenode namenode $command
	fi
}

# This section is supposed to add all datanodes names to /etc/hosts of resourcemanager pod.
# WIP solution. Refer to issue #4 on https://github.com/hrchlhck/k8s-bigdata
function add_host() {
	local pod_name=$1
	local datanodes=($(kubectl get pods -n $NAMESPACE -o wide --no-headers | awk '{if ($1 ~ /datanode/) {print ($1","$6)};}'))

	for datanode in "${datanodes[@]}"; do
		name=$(echo $datanode | awk '{split($1, a, ","); print a[1]}')
		ip=$(echo $datanode | awk '{split($1, a, ","); print a[2]}')

		
		if [[ $pod_name == "datanodes" ]]; then
			for _datanode in "${datanodes[@]}"; do
				_name=$(echo $_datanode | awk '{split($1, a, ","); print a[1]}')
				has_host $name $_name nodemanager
				ret1=$?
				has_host $name $_name datanode
				ret2=$?
				if [[ $ret1 == 0 || $ret2 == 0 ]]; then
					echo "Adding $ip $name to $_name"
					kubectl exec -it $_name -c datanode -n $NAMESPACE -- /bin/bash -c "echo -e ${ip} ${name} >> /etc/hosts"
					kubectl exec -it $_name -c nodemanager -n $NAMESPACE -- /bin/bash -c "echo -e ${ip} ${name} >> /etc/hosts"
				else
					echo "$_name already contains $ip $name"
				fi
			done
		else
			has_host $name $pod_name
			ret=$?
			if [[ $ret == 0 ]]; then
				echo "Adding $ip $name to $pod_name"
				kubectl exec -it $pod_name -n $NAMESPACE -- /bin/bash -c "echo -e ${ip} ${name} >> /etc/hosts"
			else
				echo "$pod_name already contains $ip $name"
			fi
		fi
	done
}

# Wait for pod to be ready
function wait_pods() {
	local pods=($(kubectl get pods -n $NAMESPACE --no-headers | awk '{print $1};'))
	for pod in "${pods[@]}"; do
		echo "Waiting for pod $pod"
		while [ "$(kubectl get pods $pod -n $NAMESPACE -o jsonpath='{.status.phase}')" != "Running" ]; do
			echo "waiting"
			sleep 3
		done
	done

}

# Removes previous hibench.report files present on 'namenode' pod
function rm_prev_report() {
	podexec namenode namenode "rm /hibench/report/hibench.report"
}

# Deletes HiBench generated input from HDFS
function clear_hdfs() {
	podexec namenode namenode "hadoop fs -rm -r /HiBench"
}

# Used to trap ctrl+c and/or when the program ends
function finish() {
	echo -e "Ending"
	save_bench_files
	rm_prev_report
	# clear_hdfs
}
