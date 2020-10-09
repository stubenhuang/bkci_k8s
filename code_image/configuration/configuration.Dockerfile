FROM bkci/jdk

LABEL maintainer="blueking"

COPY import_config.sh /data/docker/bkci/ci/configuration/
COPY new_env.properties /data/docker/bkci/ci/configuration/
COPY render_tpl /data/docker/bkci/ci/configuration/
COPY support-files /data/docker/bkci/ci/configuration/support-files

RUN chmod +x /data/docker/bkci/ci/configuration/import_config.sh \
    && chmod +x /data/docker/bkci/ci/configuration/render_tpl