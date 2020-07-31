#!/bin/sh
echo "确认目录下有解压的release包,命名为bkci"
echo "先修改 bkci/test_image/bkci/scripts/bkenv.properties"
echo "5秒后开始执行..."
# sleep 5s

echo "导入环境变量开始..."
source ../env.properties
source bkci/scripts/bkenv.properties
mkdir -p tmp && rm -rf tmp/*
echo "导入环境变量完成!!!"

## 初始化数据库
echo "初始化数据库开始..."
for SQL in bkci/support-files/sql/*.sql; do mysql -h$MYSQL_IP0 -P$MYSQL_PORT  -u$MYSQL_USER -p$MYSQL_PASS< $SQL; done
echo "初始化数据库完成!!!"

##打包gateway镜像
echo "打包gateway镜像开始..."
rm -rf tmp/*
cp -rf bkci/frontend tmp/
cp -rf bkci/gateway/core tmp/gateway
cp -rf gateway/gateway_run.sh tmp/
cd bkci/scripts/
./render_tpl -m ci ../support-files/templates/gateway*
./render_tpl -m ci ../frontend/pipeline/frontend#pipeline#index.html
./render_tpl -m ci ../frontend/console/frontend#console#index.html
cd ../..
cp -r $INSTALL_PATH/ci/gateway/core/* tmp/gateway/
cp $INSTALL_PATH/ci/frontend/pipeline/index.html tmp/frontend/pipeline/
cp $INSTALL_PATH/ci/frontend/console/index.html tmp/frontend/console/
docker build -f gateway/gateway.Dockerfile -t $hub/gateway:1.0 ./tmp --network=host
docker push $hub/gateway:1.0
echo "打包gateway镜像完成!!!"

## 打包backend镜像
echo "打包backend镜像开始..."
backends=(process dispatch store artifactory image log notify openapi plugin quality repository ticket project misc websocket environment)
for var in ${backends[@]};
do
    echo "build $var start..."

    rm -rf tmp/*
    cp -r backend/classpath tmp/
    cp -r backend/bootstrap tmp/
    cp backend/module_run.sh tmp/
    cp bkci/$var/boot-$var.jar tmp/

    if [ $var = 'environment'] || [ $var = 'dispatch' ]; then
        cp -rf bkci/agent-package tmp
        dos2unix tmp/agent-package/script/linux/*
        dos2unix tmp/agent-package/script/macos/*
    fi

    docker build -f backend/$var.Dockerfile -t $hub/bkci-$var:1.0 tmp
    docker push $hub/bkci-$var:1.0
    echo "build $var finish..."
done


#导入后台配置文件
echo '导入backend配置文件中...'
rm -rf tmp/* 
cp -rf bkci/scripts tmp/
cp -rf bkci/support-files tmp/
cd tmp/scripts
./render_tpl -m ci ../support-files/templates/*.yml
backends=(process dispatch store artifactory image log notify openapi plugin quality repository ticket project misc websocket dockerhost environment)
cd ..
echo '[' > consul_kv.json
for var in ${backends[@]};
do
    echo "properties $var start..."
    yaml_base64=$(base64 /data/docker/bkci/etc/ci/application-$var.yml -w 0)
    echo '	{' >> consul_kv.json
    echo '		"key": "config/'$var'ci:dev/data",' >> consul_kv.json
    echo '		"flags": 0,' >> consul_kv.json
    echo '      "value":"'$yaml_base64'"' >> consul_kv.json
    echo '	},' >> consul_kv.json
    echo "properties $var finish..."
done

echo "properties application start..."
yaml_base64=$(base64 /data/docker/bkci/etc/ci/common.yml -w 0)
echo '	{' >> consul_kv.json
echo '		"key": "config/application:dev/data",' >> consul_kv.json
echo '		"flags": 0,' >> consul_kv.json
echo '      "value":"'$yaml_base64'"' >> consul_kv.json
echo '	}' >> consul_kv.json
echo "properties application finish..."
echo ']' >> consul_kv.json
kubectl cp consul_kv.json consul-server-0:/
kubectl exec -it consul-server-0 -- consul kv import --http-addr=127.0.0.1:8500 @consul_kv.json
cd ..
echo '导入backend配置文件完成!!!'