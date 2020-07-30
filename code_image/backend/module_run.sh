#! /bin/sh
nohup consul agent -datacenter=dc -domain=ci -data-dir=/tmp -join=consul-server &
java -cp boot-$module.jar -Dservice-suffix=ci -Dloader.path="/data/docker/bkci/ci/backend/classpath/" org.springframework.boot.loader.PropertiesLauncher --spring.profiles.active=dev --spring.cloud.config.enabled=false --spring.config.location=/data/docker/bkci/ci/backend/bootstrap/bootstrap.yaml