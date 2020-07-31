## 构建机节点有两种添加方式
1. 单机构建(集群构建是将单机进行逻辑分类,这里不详述)
2. DockerHost构建

## 单机构建
在页面进行配置即可 , 在创建完项目之后 , 进入"环境管理"-->"节点"-->"导入节点" , 根据提示操作即可

## dockerhost部署
1. 确保本机能够ssh上dockerhost的机器
2. dockerhost的机器安装有jdk8且可以运行java(建议使用https://github.com/Tencent/TencentKona-8/releases)
3. 在创建worker-agent的目录:
    - /data/docker/bkci/public/ci/docker/workspace : 用于存放构建的数据
    - /data/docker/bkci/public/ci/docker/apps/ : 用于创建构建的依赖(比如go , maven , gradle等)
    - 在/data/docker/bkci/public/ci/docker/apps/上放上jdk目录 , 并且确定/data/docker/bkci/public/ci/docker/apps/jdk/bin/java 可以运行
4. 执行deploy.sh