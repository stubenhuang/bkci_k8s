#!/bin/bash
set -e
echo "导入环境变量开始..."
source ../env.properties
mkdir -p tmp && rm -rf tmp/*
echo "导入环境变量完成"

##打包gateway镜像
echo "打包gateway镜像开始..."
rm -rf tmp/*
cp -rf bkci/frontend tmp/
cp -rf bkci/gateway/core tmp/gateway
cp -rf gateway/gateway_run.sh tmp/
cp -rf gateway/render_tpl tmp/
cp -rf bkci/support-files tmp/
docker build -f gateway/gateway.Dockerfile -t $hub/bkci-gateway:1.0 ./tmp --network=host
docker push $hub/bkci-gateway:1.0
echo "打包gateway镜像完成"

## 打包backend镜像
echo "打包backend镜像开始..."
backends=(process dispatch store artifactory image log notify openapi plugin quality repository ticket project misc websocket environment dockerhost)
for var in ${backends[@]};
do
    echo "build $var start..."

    rm -rf tmp/*
    cp -r backend/classpath tmp/
    cp -r backend/bootstrap tmp/
    cp -r backend/font tmp/
    cp bkci/$var/boot-$var.jar tmp/

    if [ $var = 'dockerhost' ]; then
        cp backend/dockerhost/module_run.sh tmp/
        cp backend/dockerhost/init.sh tmp/
        cp -r ../base_image/jdk tmp/
    else
        cp backend/module_run.sh tmp/
    fi

    if [ $var = 'environment' ] || [ $var = 'dispatch' ]; then
        cp -rf bkci/agent-package tmp
        dos2unix tmp/agent-package/script/linux/*
        dos2unix tmp/agent-package/script/macos/*
    fi

    docker build -f backend/$var.Dockerfile -t $hub/bkci-$var:1.0 tmp --network=host
    docker push $hub/bkci-$var:1.0
    echo "build $var finish..."
done

## 打包配置镜像
echo '打包配置镜像中...'
rm -rf tmp/*
cp -rf bkci/support-files tmp/
cp -rf configuration/import_config.sh tmp/ 
cp -rf configuration/render_tpl tmp/ 
docker build -f configuration/configuration.Dockerfile -t $hub/bkci-configuration:1.0 tmp --network=host
docker push $hub/bkci-configuration:1.0
echo '打包配置镜像完成'

set +e