#! /bin/sh
consul_server=10.0.1.3
nohup consul agent -datacenter=dc -domain=ci -data-dir=/tmp -join=$consul_server &
/usr/local/openresty/nginx/sbin/nginx 
tail -f /dev/null