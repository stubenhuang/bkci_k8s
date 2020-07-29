### 目录说明
```
base_image/: 基础镜像
    jdk/: jdk目录
    linux/: linux的一些工具
    dockerfile/: 基础镜像的Dockerfile
    build.sh: 构建脚本

code_image/: 代码镜像
    backend/: 后端构建
    gateway/: 网关构建
    build.sh: 构建脚本

deploy_yaml/: k8s部署
    base/: 基础服务部署
        ingress-nginx: 定制化的ingress-nginx的helm
        ingress.example.yaml: ingress配置模板
        deploy.sh:部署脚本
    business/: 业务服务部署
        backend/: 后端部署
        gateway/: 前端部署
        deploy.sh: 部署脚本

env.example.properties: 变量配置模板
```

### 环境准备:
1. 搭建好k8s集群
2. 安装mysql5.7, redis2.8, rabbitmq3.8, es5.6, consul1.8
3. 找一台物理机器安装nfs
    - 共享 /data/nfs目录 
    - mkdir /data/nfs/consul
    - mkdir /data/nfs/artifactory
    - mkdir /data/nfs/environment
4. 所有宿主机需要安装: nfs-common , nfs-utils
5. 在code_image目录下: 
    - 到https://github.com/Tencent/bk-ci/releases/ 下载最新的release包, 解压
    - 将 bkci/support-files/file拷贝到 nfs服务器的/data/nfs/artifactory/
    - 在 nfs服务器的/data/nfs/environment/中,创建agent-package/jre(目录结构参考https://github.com/Tencent/bk-ci/tree/master/support-files/agent-package/jre)
    - 在 nfs服务器的/data/nfs/environment/中,创建agent-package/packages中(目录结构参考https://github.com/Tencent/bk-ci/tree/master/support-files/agent-package/packages) 
6. 在nfs服务器/data/nfs/environment/的jre和packages文件夹中, 根据每个目录下的README.md , 将jre.zip和unzip.exe准备好(可以在Windows的git的/usr/bin里面找到)
7. 复制env.example.properties,命名为env.properties,修改为自己想要的变量
8. 复制deploy_yaml/base/ingress.example.yaml, 命名为ingress.yaml, 修改自己为自己的域名
9. 下载consul到base_image/linux/目录下(确保base_image/linux/consul可执行)


## 打包基础镜像
1. 确认本地有安装docker
2. 进入base_image目录 , 打开buildenv.properties , 修改属性
3. 执行build.sh


## 打包代码镜像
1. 确认本地有安装docker,consul
2. 打开code_image目录 , 修改buildenv.properties
3. 修改 bkci/scripts/bkenv.properties 
    - INSTALL_PATH和MODULE不要修改(否则镜像挂载会有问题)
    - 其他的跟自己的环境对应上
4. 执行build.sh
5. 根据bkci/scripts/bkenv.properties 变量 , 在rabbitmq中执行:
    - rabbitmqctl add_vhost ${RABBITMQ_VHOST}
    - rabbitmqctl set_permissions -p ${RABBITMQ_VHOST} ${RABBITMQ_USERNAME} ".*" ".*" ".*"


## 部署服务
1. 确定本地安装有helm2 , kubectl(已经配好集群)
2. 部署基础服务: ingress-nginx和consul
    - 进入deploy_yaml/base 
    - 执行deploy.sh
3. 部署代码服务: 
    - 进入deploy_yaml/business
    - 修改deployenv.properties, 保证仓库能够拉取镜像,保证nfs服务器正常
    - 执行deploy.sh