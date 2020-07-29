echo '脚本使用helm2 安装, 注意helm3语法有区别'
echo '脚本15s后执行 , 取消请按CTRL+C'
sleep 15s

# 把所有node都打上isIngress="true"的label
kubectl label node --all isIngress="true"

# 安装ingress-nginx
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install -n ingress-nginx ingress-nginx/ingress-nginx -f ingress-nginx.yaml

# 配置ingress负载
kubectl apply -f ingress.yaml

echo 'ingress安装完成'
echo '注: 配置外网反向代理到ingress(如nginx或CLB)...'