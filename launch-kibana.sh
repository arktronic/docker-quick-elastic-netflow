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

[ -f "/.kibana-is-configured" ] || {
  echo First run: generating Kibana keys
  /usr/share/kibana/bin/kibana-encryption-keys generate -q >> /etc/kibana/kibana.yml
  touch /.kibana-is-configured
}

echo Launching Kibana
cd /usr/share/kibana
runuser -u kibana -- /usr/share/kibana/bin/kibana
