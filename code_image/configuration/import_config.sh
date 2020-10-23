set -e

##初始化数据库
for SQL in /data/docker/bkci/ci/configuration/support-files/sql/*.sql; do mysql -h$MYSQL_IP -P$MYSQL_PORT  -u$MYSQL_USER -p$MYSQL_PASS< $SQL; done

## 初始化配置
./render_tpl -m ci ./support-files/templates/*.yml
backends=(process dispatch store artifactory image log notify openapi plugin quality repository ticket project misc websocket dockerhost environment)
cd ..
echo '[' > consul_kv.json
for var in ${backends[@]};
do
    echo "properties $var start..."
    yaml_base64=$(base64 /data/docker/bkci/etc/ci/application-$var.yml -w 0)
    echo '	{' >> consul_kv.json
    echo '		"key": "config/'$var'ci:dev/data",' >> consul_kv.json
    echo '		"flags": 0,' >> consul_kv.json
    echo '      "value":"'$yaml_base64'"' >> consul_kv.json
    echo '	},' >> consul_kv.json
    echo "properties $var finish..."
done

echo "properties application start..."
yaml_base64=$(base64 /data/docker/bkci/etc/ci/common.yml -w 0)
echo '	{' >> consul_kv.json
echo '		"key": "config/application:dev/data",' >> consul_kv.json
echo '		"flags": 0,' >> consul_kv.json
echo '      "value":"'$yaml_base64'"' >> consul_kv.json
echo '	}' >> consul_kv.json
echo "properties application finish..."
echo ']' >> consul_kv.json

consul kv import --http-addr=$CONSUL_SERVER:8500 @consul_kv.json