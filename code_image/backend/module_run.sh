#! /bin/sh
# nohup consul agent -datacenter=dc -domain=ci -data-dir=/tmp -join=$CONSUL_SERVER &
mkdir -p /data/docker/bkci/ci/backend/logs
java -cp boot-$module.jar \
    -server \
    -Xloggc:/data/docker/bkci/ci/backend/logs/gc.log \
    -XX:NewRatio=1 \
    -XX:SurvivorRatio=8 \
    -XX:+PrintTenuringDistribution \
    -XX:+PrintGCDetails \
    -XX:+PrintGCDateStamps \
    -XX:+UseConcMarkSweepGC \
    -XX:+HeapDumpOnOutOfMemoryError \
    -XX:HeapDumpPath=oom.hprof \
    -XX:ErrorFile=error_sys.log \
    -Dservice-suffix=ci \
    -Dloader.path="/data/docker/bkci/ci/backend/classpath/" \
    -Dspring.profiles.active=dev \
    -Dspring.cloud.config.enabled=false \
    -Dservice.log.dir=/data/docker/bkci/ci/backend/logs/ \
    -Dsun.jnu.encoding=UTF-8 \
    -Dfile.encoding=UTF-8 \
    -Dspring.config.location=/data/docker/bkci/ci/backend/bootstrap/bootstrap.yaml \
    -Dspring.cloud.consul.host=$NODE_IP \
    org.springframework.boot.loader.PropertiesLauncher