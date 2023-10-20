echo "Kafka consumer groups for active consumers:"

sudo kafka-consumer-groups.sh --bootstrap-server ${KAFKA_BOOTSTRAP_SERVERS} --list