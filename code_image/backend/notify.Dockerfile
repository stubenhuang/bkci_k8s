FROM bkci/jdk

LABEL maintainer="blueking"

ENV module notify

COPY boot-notify.jar /data/docker/bkci/ci/backend/
COPY module_run.sh /data/docker/bkci/ci/backend/
COPY classpath /data/docker/bkci/ci/backend/classpath
COPY bootstrap /data/docker/bkci/ci/backend/bootstrap

RUN chmod +x /data/docker/bkci/ci/backend/module_run.sh