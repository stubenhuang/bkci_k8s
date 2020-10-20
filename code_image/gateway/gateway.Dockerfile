FROM bkci/openresty

LABEL maintainer="blueking"

COPY gateway /data/docker/bkci/ci/gateway
COPY gateway_run.sh /data/docker/bkci/ci/gateway/
COPY render_tpl /data/docker/bkci/ci/gateway/
COPY support-files /data/docker/bkci/ci/gateway/support-files
COPY frontend /data/docker/bkci/ci/frontend


## lua日志目录
RUN mkdir -p /data/docker/bkci/logs/ci/nginx/ &&\
    chown -R nobody:nobody /data/docker/bkci/logs/ci/nginx/ &&\
    rm -rf /usr/local/openresty/nginx/conf &&\
    ln -s  /data/docker/bkci/ci/gateway /usr/local/openresty/nginx/conf &&\
    mkdir -p /usr/local/openresty/nginx/run/ &&\
    chmod +x /data/docker/bkci/ci/gateway/gateway_run.sh &&\
    chmod +x /data/docker/bkci/ci/gateway/render_tpl