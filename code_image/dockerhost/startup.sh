#! /bin/sh
cd /data/docker/bkci/ci/dockerhost

consul kv get -http-addr=consul.bk.tencent.com config/application:dev/data > resources/application.yaml
consul kv get -http-addr=consul.bk.tencent.com config/dockerhostci:dev/data > resources/dockerhost.yaml

if [ -f pid ]; then
  cat pid|xargs kill
fi

nohup java  -Dservice-suffix=ci -Ddevops_gateway=devops.bk.tencent.com -Dspring.config.location=resources/application.yaml,resources/dockerhost.yaml  -jar boot-dockerhost.jar  --spring.profiles.active=dev --spring.cloud.config.enabled=false &
echo "$!"
echo "$!" > pid