## 构建机部署
- 注: dockerhost现在支持k8s进行部署了 , 所以该部署只作为备份进行参考

## 构建机节点有两种添加方式
1. 单机构建(集群构建是将单机进行逻辑分类,这里不详述)
2. 公共构建机构建(也称DockerHost构建)

## 单机构建
在页面进行配置即可 , 在创建完项目之后 , 进入"环境管理"-->"节点"-->"导入节点" , 根据提示操作即可

## 公共构建机构建
0. 在devops_ci_dispatch.T_DISPATCH_PIPELINE_DOCKER_IP_INFO上添加dockerhost机器的ip(ENABLE设置为true , 其他数据可以先随便填)
1. 确保本机能够免密ssh上dockerhost的机器
2. dockerhost的机器安装有jdk8且可以运行java(建议使用https://github.com/Tencent/TencentKona-8/releases)
3. 确保dockerhost的机器上有安装docker
4. 在dockerhost机器上创建以下目录,提供给worker-agent挂载:
    - /data/docker/bkci/public/ci/docker/workspace : 用于存放构建的数据
    - /data/docker/bkci/public/ci/docker/apps/ : 用于创建构建的依赖(这个在另一个平台上编辑,后续开放)
    - 在/data/docker/bkci/public/ci/docker/apps/上放上jdk目录 , 并且确定/data/docker/bkci/public/ci/docker/apps/jdk/bin/java 可以运行
5. 执行deploy.sh , 到dockerhost机器上确保机器启动成功
6. 在"研发商店"-->"工作台"-->"容器镜像"关联自己的镜像 , 上架成功后 , 即可在"流水线"的"公共构建机"上找到该镜像