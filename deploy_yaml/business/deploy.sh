# 使用helm安装
source ../../env.properties
helm install -n bkci ./bkci --set image.hub=$hub,volume.nfs.server=$nfs_server