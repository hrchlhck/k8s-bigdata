FROM maven:3.6.3-openjdk-8-slim

LABEL MAINTAINER "Pedro Horchulhack <pedrohorchulhack@gmail.com>"

ENV HIBENCH_VERSION=7.1.1

# Installing dependencies
RUN apt update -y
RUN apt install -y wget unzip python2

# Setting up HiBench
RUN wget https://github.com/Intel-bigdata/HiBench/archive/v${HIBENCH_VERSION}.zip
RUN unzip v${HIBENCH_VERSION}.zip -d ./HiBench
RUN rm v${HIBENCH_VERSION}.zip

WORKDIR ./HiBench/HiBench-${HIBENCH_VERSION}

# Build Apache Spark module
RUN mvn -Psparkbench clean package

# Adding configuration script and it's dependency
RUN apt install -y python3
ADD create_config.py /
ADD ./hdfs.env /
ADD ./spark.env / 
ADD entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
