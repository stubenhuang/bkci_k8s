#!/bin/bash

set -e
source ../env.properties

linux_version="1.0"
jdk_version="1.0"     # 构建的jdk镜像版本
openresty_version="1.0" # 构建的jdk镜像版本

# 打包Linux镜像
docker build -f dockerfile/bkci-linux.Dockerfile -t ${hub}/bkci-linux:${linux_version} . --network=host
docker push ${hub}/bkci-linux:${linux_version}
docker tag ${hub}/bkci-linux:${linux_version} bkci/linux

## 打包jdk镜像
docker build -f dockerfile/bkci-jdk.Dockerfile -t ${hub}/bkci-jdk:${jdk_version} . --network=host
docker push ${hub}/bkci-jdk:${jdk_version}
docker tag ${hub}/bkci-jdk:${jdk_version} bkci/jdk

## 打包openresty镜像
docker build -f dockerfile/bkci-openresty.Dockerfile -t ${hub}/bkci-openresty:${openresty_version} . --network=host
docker push ${hub}/bkci-openresty:${openresty_version}
docker tag ${hub}/bkci-openresty:${openresty_version} bkci/openresty

set +e