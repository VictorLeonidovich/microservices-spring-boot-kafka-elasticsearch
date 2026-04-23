#!/bin/bash
# check-config-server-started.sh

apt-get update -y

yes | apt-get install curl

curlResult=$(curl -s -o /dev/null -I -w "%{http_code}" http://config-server:8888/actuator/health)

echo "result status code:" "$curlResult"

while [[ ! $curlResult == "200" ]]; do
  >&2 echo "Config server is not up yet!"
  sleep 2
  curlResult=$(curl -s -o /dev/null -I -w "%{http_code}" http://config-server:8888/actuator/health)
  echo "result status code:" "$curlResult"
done

echo "DEBUG: Kafka Bootstrap is set to: $SPRING_KAFKA_BOOTSTRAP_SERVERS"

echo "Waiting 20 sec for Kafka brokers to stabilize..."
sleep 20

cd /
#./cnb/lifecycle/launcher
/cnb/process/web --spring.kafka.bootstrap-servers=kafka-broker-1:9092,kafka-broker-2:9092,kafka-broker-3:9092 --spring.kafka.admin.properties.bootstrap.servers=kafka-broker-1:9092,kafka-broker-2:9092,kafka-broker-3:9092