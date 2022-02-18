#!/bin/bash

VAR_DEPLOY_DIR="/usr/spring-boot-demo"
cd $VAR_DEPLOY_DIR

VAR_PIDS=`ps aux | grep java | grep "$VAR_DEPLOY_DIR" | grep -v grep | grep -v "kill.sh" | awk '{print $1}'`

if [ -z "$VAR_PIDS" ]; then
echo "no process"
false
else
kill -s 9 $VAR_PIDS
true
fi
