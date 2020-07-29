FROM bkci/openresty

LABEL maintainer="blueking"

## frontend 的目录是写死的  有点蛋疼
COPY gateway /data/docker/bkci/ci/gateway
COPY frontend /data/docker/bkci/ci/frontend
COPY gateway_run.sh /data/docker/bkci/ci/gateway/


## lua日志目录
RUN mkdir -p /data/docker/bkci/logs/ci/nginx/ &&\
    chown -R nobody:nobody /data/docker/bkci/logs/ci/nginx/ &&\
    rm -rf /usr/local/openresty/nginx/conf &&\
    ln -s  /data/docker/bkci/ci/gateway /usr/local/openresty/nginx/conf &&\
    mkdir -p /usr/local/openresty/nginx/run/ &&\
    chmod +x /data/docker/bkci/ci/gateway/gateway_run.sh