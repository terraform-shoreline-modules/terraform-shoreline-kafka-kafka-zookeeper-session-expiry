

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