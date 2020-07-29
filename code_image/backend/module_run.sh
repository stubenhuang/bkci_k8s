#! /bin/sh
consul_server=10.0.1.3
nohup consul agent -datacenter=dc -domain=ci -data-dir=/tmp -join=$consul_server &
java -cp boot-$module.jar -Dservice-suffix=ci -Dloader.path="/data/docker/bkci/ci/backend/classpath/" org.springframework.boot.loader.PropertiesLauncher --spring.profiles.active=dev --spring.cloud.config.enabled=false --spring.config.location=/data/docker/bkci/ci/backend/bootstrap/bootstrap.yaml