#! /bin/sh
nohup consul agent -datacenter=dc -domain=ci -data-dir=/tmp -join=consul-server &
/usr/local/openresty/nginx/sbin/nginx 
tail -f /dev/null