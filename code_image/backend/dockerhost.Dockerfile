FROM bkci/jdk

LABEL maintainer="blueking"

ENV module dockerhost

COPY boot-dockerhost.jar /data/docker/bkci/ci/backend/
COPY module_run.sh /data/docker/bkci/ci/backend/
COPY classpath /data/docker/bkci/ci/backend/classpath
COPY bootstrap /data/docker/bkci/ci/backend/bootstrap
COPY init.sh /base/
COPY jdk /base/jdk

RUN chmod +x /data/docker/bkci/ci/backend/module_run.sh
