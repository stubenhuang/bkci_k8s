#! /bin/sh

##初始化配置
$INSTALL_PATH/ci/gateway/render_tpl -m ci $INSTALL_PATH/ci/gateway/support-files/templates/gateway*
$INSTALL_PATH/ci/gateway/render_tpl -m ci $INSTALL_PATH/ci/frontend/pipeline/frontend#pipeline#index.html
$INSTALL_PATH/ci/gateway/render_tpl -m ci $INSTALL_PATH/ci/frontend/console/frontend#console#index.html
cp -rf $INSTALL_PATH/ci/gateway/core/* $INSTALL_PATH/ci/gateway/

##启动程序
nohup consul agent -datacenter=$CONSUL_DATACENTER -domain=$BK_CI_CONSUL_DOMAIN -data-dir=/tmp -join=$CONSUL_SERVER &
/usr/local/openresty/nginx/sbin/nginx 
tail -f /dev/null