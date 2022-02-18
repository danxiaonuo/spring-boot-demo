#!/bin/bash

source /etc/profile

cd `dirname $0`
VAR_BIN_DIR=`pwd`
cd ..
VAR_DEPLOY_DIR=`pwd`
VAR_LOG_DIR=$VAR_DEPLOY_DIR/logs
VAR_STDOUT_FILE=$VAR_LOG_DIR/stdout.log
# SKYWALKING链路跟踪
SKYWALKING_OPTIONS="-javaagent:/usr/skywalking/agent/skywalking-agent.jar -Dskywalking.agent.namespace=test -Dskywalking.agent.service_name=spring-boot-mini -Dskywalking.collector.backend_service=sky.iflytek.com:31066"

if [ ! -d $VAR_LOG_DIR ]; then
    mkdir $VAR_LOG_DIR
fi

if [ -n "$1" ]; then
    VAR_JAVA_OPTS=""
    echo "开发模式启动..."
else
    VAR_JAVA_OPTS="-Xmx1550m -Xms1550m -XX:MetaspaceSize=128M -XX:MaxMetaspaceSize=128M -Xss256K -XX:+UseConcMarkSweepGC -XX:+UseParNewGC"
fi

#入口
MAIN_CLASS="com.iflytek.iptv.Main"

# 启动时同步加载conf、resources、lib目录下的资源
nohup java $VAR_JAVA_OPTS $SKYWALKING_OPTIONS -cp `pwd`/conf:`pwd`/resources:`pwd`/lib/* $MAIN_CLASS > $VAR_STDOUT_FILE > /dev/null 2>&1 &

VAR_PIDS=`ps aux | grep java | grep "$VAR_DEPLOY_DIR" | grep -v grep | grep -v "start.sh" | awk '{print $2}'`
echo "PID: $VAR_PIDS"
#开发环境启动方式 sh start.sh debug
