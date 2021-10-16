#!/bin/bash
echo Waiting for ES to start...
COUNTER=0
COMMAND_STATUS=1
until [ $COMMAND_STATUS -eq 0 ] || [ $COUNTER -eq 6 ]; do
  curl -m 5 -s http://localhost:9200/_cluster/health | jq '.status' | grep green 2>&1 >/dev/null
  COMMAND_STATUS=$?
  [ $COMMAND_STATUS -eq 0 ] || sleep 10
  let COUNTER=COUNTER+1
done

[ $COMMAND_STATUS -eq 0 ] || {
  echo Timed out waiting for ES to start!
  exit 1
}

echo Waiting for Kibana to start...
COUNTER=0
COMMAND_STATUS=1
until [ $COMMAND_STATUS -eq 0 ] || [ $COUNTER -eq 6 ]; do
  curl -m 5 -s http://localhost:5601/api/task_manager/_health | jq '.status' | grep OK 2>&1 >/dev/null
  COMMAND_STATUS=$?
  [ $COMMAND_STATUS -eq 0 ] || sleep 10
  let COUNTER=COUNTER+1
done

[ $COMMAND_STATUS -eq 0 ] || {
  echo Timed out waiting for Kibana to start!
  exit 1
}

[ -f "/.filebeat-is-configured" ] || {
  echo First run: configuring Filebeat
  filebeat setup --index-management || exit 1
  filebeat setup --dashboards || exit 1
  filebeat setup --pipelines || exit 1
  touch /.filebeat-is-configured
}

# ensure replicas are disabled
curl -XPUT 'http://localhost:9200/_all/_settings' -H 'Content-Type: application/json' -d '{
  "index.number_of_replicas" : "0"
}'

echo Launching Filebeat
/usr/bin/filebeat -e
