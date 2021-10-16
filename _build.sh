#!/bin/bash
cd "${0%/*}"
docker build -t localhost/arktronic/quick-elastic-netflow .
