#! /bin/sh
echo "执行之前请阅读README.md"
echo "10s后开始执行"

source ./deployenv.properties
ssh -p $dockerhost_port $dockerhost_user@$dockerhost_ip "mkdir -p /data/docker/bkci/ci/dockerhost/resources;mkdir -p /data/docker/bkci/ci/dockerhost/logs;;mkdir -p /data/docker/bkci/ci/agent-package/script"
scp -P $dockerhost_port ../bkci/dockerhost/boot-dockerhost.jar startup.sh $dockerhost_user@$dockerhost_ip:/data/docker/bkci/ci/dockerhost/
scp -P $dockerhost_port init.sh $dockerhost_user@$dockerhost_ip:/data/docker/bkci/ci/agent-package/script/
ssh -p $dockerhost_port $dockerhost_user@$dockerhost_ip "/bin/sh -c /data/docker/bkci/ci/dockerhost/startup.sh"