
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Kafka ZooKeeper Session Expiry Incident.
---

This incident type refers to an issue with the Apache Kafka distributed streaming platform where the connection between the Kafka brokers and the ZooKeeper ensemble is interrupted due to the expiration of ZooKeeper session. This may result in temporary unavailability of Kafka brokers, leading to data loss or system downtime. The incident requires immediate attention and resolution to restore normal system operation.

### Parameters
```shell
export ZOOKEEPER_LOG_FILE_PATH="PLACEHOLDER"

export KAFKA_LOG_FILE_PATH="PLACEHOLDER"

export KAFKA_SERVER_PROPERTIES_FILE_PATH="PLACEHOLDER"

export TOPIC_NAME="PLACEHOLDER"

export ZOOKEEPER_CONNECTION_STRING="PLACEHOLDER"

export KAFKA_BOOTSTRAP_SERVERS="PLACEHOLDER"

export CONSUMER_GROUP_NAME="PLACEHOLDER"

```

## Debug

### Check ZooKeeper status
```shell
echo "ZooKeeper status:"

sudo systemctl status zookeeper.service
```

### Check Kafka status
```shell
echo "Kafka status:"

sudo systemctl status kafka.service
```

### Check ZooKeeper logs for errors
```shell
echo "ZooKeeper logs:"

sudo grep -i error ${ZOOKEEPER_LOG_FILE_PATH}
```

### Check Kafka logs for errors
```shell
echo "Kafka logs:"

sudo grep -i error ${KAFKA_LOG_FILE_PATH}
```

### Check the ZooKeeper session timeout value
```shell
echo "ZooKeeper session timeout value:"

sudo grep -i session.timeout.ms ${KAFKA_SERVER_PROPERTIES_FILE_PATH}
```

### Check the Kafka broker configuration for ZooKeeper connection string
```shell
echo "Kafka broker configuration for ZooKeeper connection string:"

sudo grep -i zookeeper.connect ${KAFKA_SERVER_PROPERTIES_FILE_PATH}
```

### Check the Kafka topic configuration for replication factor
```shell
echo "Kafka topic configuration for replication factor:"

sudo kafka-topics.sh --describe --zookeeper ${ZOOKEEPER_CONNECTION_STRING} --topic ${TOPIC_NAME}
```

### Check the Kafka consumer groups for active consumers
```shell
echo "Kafka consumer groups for active consumers:"

sudo kafka-consumer-groups.sh --bootstrap-server ${KAFKA_BOOTSTRAP_SERVERS} --list
```

### Check the Kafka consumer group lag for a specific topic
```shell
echo "Kafka consumer group lag for a specific topic:"

sudo kafka-consumer-groups.sh --bootstrap-server ${KAFKA_BOOTSTRAP_SERVERS} --describe --group ${CONSUMER_GROUP_NAME} --topic ${TOPIC_NAME}
```

## Repair

### Increase the ZooKeeper session timeout value to avoid expirations.
```shell


#!/bin/bash



# Set the new ZooKeeper session timeout value

NEW_TIMEOUT=${NEW_TIMEOUT_VALUE}



# Find the ZooKeeper configuration file

ZOOKEEPER_CONF=${ZOOKEEPER_CONF_FILE}



# Check if the configuration file exists

if [ ! -f "$ZOOKEEPER_CONF" ]; then

  echo "Error: ZooKeeper configuration file not found."

  exit 1

fi



# Update the ZooKeeper session timeout value in the configuration file

sed -i "s/^sessionTimeout=[0-9]\+$/sessionTimeout=$NEW_TIMEOUT/" "$ZOOKEEPER_CONF"



# Restart the ZooKeeper service to apply the new configuration

systemctl restart zookeeper.service


```

### Configure Kafka to automatically re-establish a connection when a ZooKeeper session expires.
```shell


#!/bin/bash



# Stop Kafka services

sudo systemctl stop kafka



# Add the following properties to the Kafka configuration file

echo "auto.create.topics.enable=true" | sudo tee -a ${KAFKA_CONFIG_FILE_PATH}

echo "auto.leader.rebalance.enable=true" | sudo tee -a ${KAFKA_CONFIG_FILE_PATH}

echo "zookeeper.session.timeout.ms=${NEW_ZOOKEEPER_SESSION_TIMEOUT}" | sudo tee -a ${KAFKA_CONFIG_FILE_PATH}

echo "zookeeper.connection.timeout.ms=${NEW_ZOOKEEPER_CONNECTION_TIMEOUT}" | sudo tee -a ${KAFKA_CONFIG_FILE_PATH}

echo "zookeeper.sync.time.ms=${NEW_ZOOKEEPER_SYNC_TIME}" | sudo tee -a ${KAFKA_CONFIG_FILE_PATH}



# Start Kafka services

sudo systemctl start kafka


```