echo "Kafka consumer group lag for a specific topic:"

sudo kafka-consumer-groups.sh --bootstrap-server ${KAFKA_BOOTSTRAP_SERVERS} --describe --group ${CONSUMER_GROUP_NAME} --topic ${TOPIC_NAME}