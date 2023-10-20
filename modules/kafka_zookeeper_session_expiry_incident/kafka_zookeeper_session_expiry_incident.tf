resource "shoreline_notebook" "kafka_zookeeper_session_expiry_incident" {
  name       = "kafka_zookeeper_session_expiry_incident"
  data       = file("${path.module}/data/kafka_zookeeper_session_expiry_incident.json")
  depends_on = [shoreline_action.invoke_zk_status,shoreline_action.invoke_kafka_status,shoreline_action.invoke_zookeeper_logs,shoreline_action.invoke_kafka_logs,shoreline_action.invoke_get_kafka_session_timeout,shoreline_action.invoke_kafka_zookeeper_config,shoreline_action.invoke_kafka_topic_config,shoreline_action.invoke_kafka_consumer_groups,shoreline_action.invoke_kafka_consumer_group_lag,shoreline_action.invoke_update_zookeeper_timeout,shoreline_action.invoke_kafka_config_update]
}

resource "shoreline_file" "zk_status" {
  name             = "zk_status"
  input_file       = "${path.module}/data/zk_status.sh"
  md5              = filemd5("${path.module}/data/zk_status.sh")
  description      = "Check ZooKeeper status"
  destination_path = "/tmp/zk_status.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "kafka_status" {
  name             = "kafka_status"
  input_file       = "${path.module}/data/kafka_status.sh"
  md5              = filemd5("${path.module}/data/kafka_status.sh")
  description      = "Check Kafka status"
  destination_path = "/tmp/kafka_status.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "zookeeper_logs" {
  name             = "zookeeper_logs"
  input_file       = "${path.module}/data/zookeeper_logs.sh"
  md5              = filemd5("${path.module}/data/zookeeper_logs.sh")
  description      = "Check ZooKeeper logs for errors"
  destination_path = "/tmp/zookeeper_logs.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "kafka_logs" {
  name             = "kafka_logs"
  input_file       = "${path.module}/data/kafka_logs.sh"
  md5              = filemd5("${path.module}/data/kafka_logs.sh")
  description      = "Check Kafka logs for errors"
  destination_path = "/tmp/kafka_logs.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "get_kafka_session_timeout" {
  name             = "get_kafka_session_timeout"
  input_file       = "${path.module}/data/get_kafka_session_timeout.sh"
  md5              = filemd5("${path.module}/data/get_kafka_session_timeout.sh")
  description      = "Check the ZooKeeper session timeout value"
  destination_path = "/tmp/get_kafka_session_timeout.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "kafka_zookeeper_config" {
  name             = "kafka_zookeeper_config"
  input_file       = "${path.module}/data/kafka_zookeeper_config.sh"
  md5              = filemd5("${path.module}/data/kafka_zookeeper_config.sh")
  description      = "Check the Kafka broker configuration for ZooKeeper connection string"
  destination_path = "/tmp/kafka_zookeeper_config.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "kafka_topic_config" {
  name             = "kafka_topic_config"
  input_file       = "${path.module}/data/kafka_topic_config.sh"
  md5              = filemd5("${path.module}/data/kafka_topic_config.sh")
  description      = "Check the Kafka topic configuration for replication factor"
  destination_path = "/tmp/kafka_topic_config.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "kafka_consumer_groups" {
  name             = "kafka_consumer_groups"
  input_file       = "${path.module}/data/kafka_consumer_groups.sh"
  md5              = filemd5("${path.module}/data/kafka_consumer_groups.sh")
  description      = "Check the Kafka consumer groups for active consumers"
  destination_path = "/tmp/kafka_consumer_groups.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "kafka_consumer_group_lag" {
  name             = "kafka_consumer_group_lag"
  input_file       = "${path.module}/data/kafka_consumer_group_lag.sh"
  md5              = filemd5("${path.module}/data/kafka_consumer_group_lag.sh")
  description      = "Check the Kafka consumer group lag for a specific topic"
  destination_path = "/tmp/kafka_consumer_group_lag.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_zookeeper_timeout" {
  name             = "update_zookeeper_timeout"
  input_file       = "${path.module}/data/update_zookeeper_timeout.sh"
  md5              = filemd5("${path.module}/data/update_zookeeper_timeout.sh")
  description      = "Increase the ZooKeeper session timeout value to avoid expirations."
  destination_path = "/tmp/update_zookeeper_timeout.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "kafka_config_update" {
  name             = "kafka_config_update"
  input_file       = "${path.module}/data/kafka_config_update.sh"
  md5              = filemd5("${path.module}/data/kafka_config_update.sh")
  description      = "Configure Kafka to automatically re-establish a connection when a ZooKeeper session expires."
  destination_path = "/tmp/kafka_config_update.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_zk_status" {
  name        = "invoke_zk_status"
  description = "Check ZooKeeper status"
  command     = "`chmod +x /tmp/zk_status.sh && /tmp/zk_status.sh`"
  params      = []
  file_deps   = ["zk_status"]
  enabled     = true
  depends_on  = [shoreline_file.zk_status]
}

resource "shoreline_action" "invoke_kafka_status" {
  name        = "invoke_kafka_status"
  description = "Check Kafka status"
  command     = "`chmod +x /tmp/kafka_status.sh && /tmp/kafka_status.sh`"
  params      = []
  file_deps   = ["kafka_status"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_status]
}

resource "shoreline_action" "invoke_zookeeper_logs" {
  name        = "invoke_zookeeper_logs"
  description = "Check ZooKeeper logs for errors"
  command     = "`chmod +x /tmp/zookeeper_logs.sh && /tmp/zookeeper_logs.sh`"
  params      = ["ZOOKEEPER_LOG_FILE_PATH"]
  file_deps   = ["zookeeper_logs"]
  enabled     = true
  depends_on  = [shoreline_file.zookeeper_logs]
}

resource "shoreline_action" "invoke_kafka_logs" {
  name        = "invoke_kafka_logs"
  description = "Check Kafka logs for errors"
  command     = "`chmod +x /tmp/kafka_logs.sh && /tmp/kafka_logs.sh`"
  params      = ["KAFKA_LOG_FILE_PATH"]
  file_deps   = ["kafka_logs"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_logs]
}

resource "shoreline_action" "invoke_get_kafka_session_timeout" {
  name        = "invoke_get_kafka_session_timeout"
  description = "Check the ZooKeeper session timeout value"
  command     = "`chmod +x /tmp/get_kafka_session_timeout.sh && /tmp/get_kafka_session_timeout.sh`"
  params      = ["KAFKA_SERVER_PROPERTIES_FILE_PATH"]
  file_deps   = ["get_kafka_session_timeout"]
  enabled     = true
  depends_on  = [shoreline_file.get_kafka_session_timeout]
}

resource "shoreline_action" "invoke_kafka_zookeeper_config" {
  name        = "invoke_kafka_zookeeper_config"
  description = "Check the Kafka broker configuration for ZooKeeper connection string"
  command     = "`chmod +x /tmp/kafka_zookeeper_config.sh && /tmp/kafka_zookeeper_config.sh`"
  params      = ["KAFKA_SERVER_PROPERTIES_FILE_PATH"]
  file_deps   = ["kafka_zookeeper_config"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_zookeeper_config]
}

resource "shoreline_action" "invoke_kafka_topic_config" {
  name        = "invoke_kafka_topic_config"
  description = "Check the Kafka topic configuration for replication factor"
  command     = "`chmod +x /tmp/kafka_topic_config.sh && /tmp/kafka_topic_config.sh`"
  params      = ["TOPIC_NAME","ZOOKEEPER_CONNECTION_STRING"]
  file_deps   = ["kafka_topic_config"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_topic_config]
}

resource "shoreline_action" "invoke_kafka_consumer_groups" {
  name        = "invoke_kafka_consumer_groups"
  description = "Check the Kafka consumer groups for active consumers"
  command     = "`chmod +x /tmp/kafka_consumer_groups.sh && /tmp/kafka_consumer_groups.sh`"
  params      = ["KAFKA_BOOTSTRAP_SERVERS"]
  file_deps   = ["kafka_consumer_groups"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_consumer_groups]
}

resource "shoreline_action" "invoke_kafka_consumer_group_lag" {
  name        = "invoke_kafka_consumer_group_lag"
  description = "Check the Kafka consumer group lag for a specific topic"
  command     = "`chmod +x /tmp/kafka_consumer_group_lag.sh && /tmp/kafka_consumer_group_lag.sh`"
  params      = ["TOPIC_NAME","CONSUMER_GROUP_NAME","KAFKA_BOOTSTRAP_SERVERS"]
  file_deps   = ["kafka_consumer_group_lag"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_consumer_group_lag]
}

resource "shoreline_action" "invoke_update_zookeeper_timeout" {
  name        = "invoke_update_zookeeper_timeout"
  description = "Increase the ZooKeeper session timeout value to avoid expirations."
  command     = "`chmod +x /tmp/update_zookeeper_timeout.sh && /tmp/update_zookeeper_timeout.sh`"
  params      = []
  file_deps   = ["update_zookeeper_timeout"]
  enabled     = true
  depends_on  = [shoreline_file.update_zookeeper_timeout]
}

resource "shoreline_action" "invoke_kafka_config_update" {
  name        = "invoke_kafka_config_update"
  description = "Configure Kafka to automatically re-establish a connection when a ZooKeeper session expires."
  command     = "`chmod +x /tmp/kafka_config_update.sh && /tmp/kafka_config_update.sh`"
  params      = []
  file_deps   = ["kafka_config_update"]
  enabled     = true
  depends_on  = [shoreline_file.kafka_config_update]
}

