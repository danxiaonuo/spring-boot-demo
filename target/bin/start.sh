#!/bin/bash

source /etc/profile

VAR_TIME=$(date +%Y-%m-%d)
VAR_DEPLOY_DIR="/usr/spring-boot-demo"
VAR_LOG_DIR=$VAR_DEPLOY_DIR/logs
VAR_STDOUT_FILE=$VAR_LOG_DIR/spring_boot_mini_info.log.$VAR_TIME.log
cd $VAR_DEPLOY_DIR

VAR_JAVA_OPTS="-Xmx1550m -Xms1550m -XX:MetaspaceSize=128M -XX:MaxMetaspaceSize=128M -Xss256K -XX:+UseConcMarkSweepGC -XX:+UseParNewGC"
# SKYWALKING链路跟踪
SKYWALKING_OPTIONS="-javaagent:/usr/skywalking/agent/skywalking-agent.jar -Dskywalking.agent.namespace=test -Dskywalking.agent.service_name=spring-boot-mini -Dskywalking.collector.backend_service=sky.iflytek.com:31066"

if [ ! -d $VAR_LOG_DIR ]; then
    mkdir $VAR_LOG_DIR
fi

#入口
MAIN_CLASS="com.iflytek.iptv.Main"

# 启动时同步加载conf、resources、lib目录下的资源
nohup java $VAR_JAVA_OPTS $SKYWALKING_OPTIONS -cp $VAR_DEPLOY_DIR/conf:$VAR_DEPLOY_DIR/resources:$VAR_DEPLOY_DIR/lib/* $MAIN_CLASS > $VAR_STDOUT_FILE > /dev/null 2>&1 &

VAR_PIDS=`ps aux | grep java | grep "$VAR_DEPLOY_DIR" | grep -v grep | grep -v "start.sh" | awk '{print $1}'`
tail -F $VAR_STDOUT_FILE
