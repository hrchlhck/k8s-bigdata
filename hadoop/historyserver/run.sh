#!/bin/bash

# History server
$HADOOP_HOME/bin/yarn --config $HADOOP_CONF_DIR historyserver &

# Job history
$HADOOP_HOME/bin/mapred --config $HADOOP_CONF_DIR historyserver
