#! /bin/sh
cd /data/docker/bkci/ci/dockerhost

consul kv get -http-addr=consul.bk.tencent.com config/application:dev/data > resources/application.yaml
consul kv get -http-addr=consul.bk.tencent.com config/dockerhostci:dev/data > resources/dockerhost.yaml

if [ -f pid ]; then
  cat pid|xargs kill
fi

nohup java  \
    -server \
    -Xloggc:logs/gc.log \
    -XX:NewRatio=1 \
    -XX:SurvivorRatio=8 \
    -XX:+PrintTenuringDistribution \
    -XX:+PrintGCDetails \
    -XX:+PrintGCDateStamps \
    -XX:+UseConcMarkSweepGC \
    -XX:+HeapDumpOnOutOfMemoryError \
    -XX:HeapDumpPath=oom.hprof \
    -XX:ErrorFile=error_sys.log \
    -Dspring.profiles.active=dev\
    -Dservice.log.dir=logs/ \
    -Dsun.jnu.encoding=UTF-8 \
    -Dfile.encoding=UTF-8 \
    -Dservice-suffix=ci \
    -Ddevops_gateway=devops.bk.tencent.com \
    -Dspring.cloud.config.enabled=false \
    -Dspring.config.location=resources/application.yaml,resources/dockerhost.yaml \
    -jar boot-dockerhost.jar& \
echo "$!"
echo "$!" > pid