#! /bin/sh
echo "执行之前请阅读README.md"
echo "10s后开始执行"

source ./deployenv.properties
ssh -p $dockerhost_port $dockerhost_user@$dockerhost_ip "mkdir -p /data/docker/bkci/ci/dockerhost/resources"
scp -P $dockerhost_port ../bkci/dockerhost/boot-dockerhost.jar startup.sh $dockerhost_user@$dockerhost_ip:/data/docker/bkci/ci/dockerhost/
ssh -p $dockerhost_port $dockerhost_user@$dockerhost_ip "/bin/sh -c /data/docker/bkci/ci/dockerhost/startup.sh"