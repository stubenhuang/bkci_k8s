# 使用helm安装
source ../../env.properties
if $initConfig; then
   helm3 install bkci ./bkci --set image.hub=$hub,volume.nfs.server=$nfs_server --namespace $namespace -f values.yaml
else
   helm3 install bkci ./bkci --set image.hub=$hub,volume.nfs.server=$nfs_server --no-hooks --namespace $namespace -f values.yaml
fi
