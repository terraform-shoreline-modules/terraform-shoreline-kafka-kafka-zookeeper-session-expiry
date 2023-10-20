echo "Kafka topic configuration for replication factor:"

sudo kafka-topics.sh --describe --zookeeper ${ZOOKEEPER_CONNECTION_STRING} --topic ${TOPIC_NAME}