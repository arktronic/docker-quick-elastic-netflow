#!/bin/bash

if [ $$ -eq 1 ]; then
  echo "FATAL: You must use --init when launching this container!" >&2
  exit 1
fi

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
