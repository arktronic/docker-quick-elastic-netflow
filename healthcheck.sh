#!/bin/bash
curl -s http://localhost:9200/_cluster/health | jq '.status' | grep green || exit 1
curl -s http://localhost:5601/api/task_manager/_health | jq '.status' | grep OK || exit 1
netstat -unl | grep 2055 || exit 1
