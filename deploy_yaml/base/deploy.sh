echo '脚本使用helm2 安装, 注意helm3语法有区别'
echo '脚本5s后执行 , 取消请按CTRL+C'
sleep 5s

#环境变量
source ../../env.properties

#设置存储
cat consul-nfs.yaml|sed "s/{{nfs_server}}/$nfs_server/g"|kubectl apply -f -

# 安装consul服务
helm repo add hashicorp https://helm.releases.hashicorp.com
helm install -n consul hashicorp/consul -f consul-server.yaml

# 把所有node都打上isIngress="true"的label
kubectl label node --all isIngress="true"

# 安装ingress-nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install -n ingress-nginx ingress-nginx/ingress-nginx -f ingress-nginx.yaml

# 配置ingress负载
kubectl apply -f ingress.yaml

echo 'ingress安装完成'
echo '注: 配置外网反向代理到ingress(如nginx或CLB)...'