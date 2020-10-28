echo '脚本使用helm3语法'
echo '脚本5s后执行 , 取消请按CTRL+C'
sleep 5s

set -e

#环境变量
source ../../env.properties

#设置存储
cat consul-nfs.yaml|sed "s/{{nfs_server}}/$nfs_server/g"|kubectl apply -f -

# 安装consul服务
helm3 repo add hashicorp https://helm.releases.hashicorp.com
helm3 install consul hashicorp/consul -f consul-server.yaml

# 把所有node都打上isIngress="true"的label
kubectl label node --all isIngress="true"

# 安装ingress-nginx
helm3 repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm3 install ingress-nginx ingress-nginx/ingress-nginx -f ingress-nginx.yaml

# 配置ingress负载
kubectl apply -f ingress.yaml

set +e

echo 'ingress安装完成'
echo '注: 配置外网反向代理到ingress(如nginx或CLB)...'