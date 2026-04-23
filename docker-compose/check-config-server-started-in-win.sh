#!/bin/bash

curlResult=$(curl -s -o /dev/null -I -w "%{http_code}" http://localhost:8888/actuator/health)

echo ":" "$curlResult"

while [[ ! $curlResult == "200" ]]; do
  >&2 echo "Config server is not up yet!"
  sleep 2
  curlResult=$(curl -s -o /dev/null -I -w "%{http_code}" http://localhost:8888/actuator/health)
done

./cnb/lifecycle/launcher