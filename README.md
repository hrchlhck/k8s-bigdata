# k8s-bigdata
Apache Spark with HDFS cluster within Kubernetes.

### Overview
As the description says, this repository is an Apache Spark with an HDFS cluster within Kubernetes. Although it contains [Intel HiBench](https://github.com/Intel-bigdata/HiBench) benchmark suite for testing CPU, IO, and network usage, the cluster can run as a regular one. 

### Supported HiBench Workloads
- Micro
- Machine Learning
- Websearch

### Building k8s-bigdata
You can just execute the `build.sh` file.
```sh
$ ./build.sh
```

### Submitting the cluster
To submit the cluster and prepare it, you must type the following `./scripts/init-cluster.sh <WORKLOAD> <BENCHMARK> <INPUT_SIZE>`
Where:
1. `WORKLOAD` represents a workload from [HiBench](https://github.com/Intel-bigdata/HiBench)
2. `BENCHMARK` represents the benchmark 
3. `INPUT_SIZE` means the size of the workload for the benchmark

### Running HiBench
To run a [HiBench](https://github.com/Intel-bigdata/HiBench) benchmark, you can run `./scripts/run.sh <WORKLOAD> <BENCHMARK>`
The report saved will be in the base directory with the name `hibench.report`.

### Features
- k8s-bigdata currently uses Apache Spark 2.4 with Hadoop 2.7 binary
- No need to register manually each `datanode`
- Kubernetes will create a `datanode` for each node registered in the cluster
- Can specify which node `namenode`, `resourcemanager`, and `historyserver` will be launched by assigning the label `type=master`. If you are new to Kubernetes, type `kubectl label nodes YOUR NODE type=master`

### Future works
- 🗴 Support data streaming frameworks such as Apache Kafka
- ✓ Switch static to dynamic environment variables for containers (avoid building on every change in `./hadoop/base/hadoop.env` file)
- ✓ Implement a configuration parser to run HiBench without changing `run.sh`
- ✓ Implement a solution to change the size of input data for HiBench benchmarks without accessing `namenode` pod directly

### Architecture
Based on the locality of reference, HiBench, Hadoop Namenode, and Spark Master are within the same container as processes. Also, HiBench needs the Hadoop and Spark directories located at the namenode pod.

![Alt text](./doc/k8s-bigdata-architecture.svg)

### References
- [Intel HiBench](https://github.com/Intel-bigdata/HiBench#hibench-suite-)
- [Docker Hadoop](https://github.com/big-data-europe/docker-hadoop)
- [Docker Spark](https://github.com/big-data-europe/docker-spark)
- [Apache Spark](https://spark.apache.org/)
- [Apache Hadoop](https://hadoop.apache.org/)
