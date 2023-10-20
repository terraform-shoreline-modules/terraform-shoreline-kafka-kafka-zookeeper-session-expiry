

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