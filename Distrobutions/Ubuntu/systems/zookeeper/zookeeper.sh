#!/bin/bash

# Import variables
source kafka_vars.sh

# Download java
sudo apt-get update
sudo apt-get install -y default-jre

# Download stable release of Zookeeper (https://zookeeper.apache.org/)
wget https://downloads.apache.org/zookeeper/zookeeper-3.7.1/apache-zookeeper-3.7.1-bin.tar.gz

# Extract Zookeeper & move it to Zookeeper directory
tar -xzf apache-zookeeper-3.7.1-bin.tar.gz
sudo mv apache-zookeeper-3.7.1-bin /opt/zookeeper

# Configure Zookeeper
cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg

echo -e "server.1=$ZOO_1_IP:2888:3888\nserver.2=$ZOO_2_IP:2888:3888\nserver.3=$ZOO_3_IP:2888:3888" >> /opt/zookeeper/conf/zoo.cfg

# Start Zookeeper Service
/opt/zookeeper/bin/zkServer.sh start

# Verify Cluster status
/opt/zookeeper/bin/zkCli.sh -server $ZOO_1_IP:2181,$ZOO_2_IP:2181,$ZOO_3_IP:2181