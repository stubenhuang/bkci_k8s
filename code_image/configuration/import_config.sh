set -e

##初始化数据库
for SQL in /data/docker/bkci/ci/configuration/support-files/sql/*.sql; do mysql -h$MYSQL_IP -P$MYSQL_PORT  -u$MYSQL_USER -p$MYSQL_PASS< $SQL; done

## 初始化配置
./render_tpl -m ci ./support-files/templates/*.yml
backends=(process dispatch store artifactory image log notify openapi plugin quality repository ticket project misc websocket dockerhost environment)
cd ..
for var in ${backends[@]};
do
    echo "properties $var start..."
    curl --request PUT --data "$(cat /data/docker/bkci/etc/ci/application-$var.yml)" http://${CONSUL_SERVER}:8500/v1/kv/config/${var}${BK_CI_CONSUL_DISCOVERY_TAG}:${BK_CI_ENV}/data
    echo "properties $var finish..."
done

echo "properties application start..."
curl --request PUT --data "$(cat /data/docker/bkci/etc/ci/common.yml)" http://${CONSUL_SERVER}:8500/v1/kv/config/application:${BK_CI_ENV}/data
echo "properties application finish..."