FROM bkci/jdk

LABEL maintainer="blueking"

ENV module environment

COPY boot-environment.jar /data/docker/bkci/ci/backend/
COPY module_run.sh /data/docker/bkci/ci/backend/
COPY agent-package /data/docker/bkci/ci/agent-package
COPY classpath /data/docker/bkci/ci/backend/classpath
COPY bootstrap /data/docker/bkci/ci/backend/bootstrap

RUN chmod +x /data/docker/bkci/ci/backend/module_run.sh
RUN rm -rf /data/docker/bkci/ci/agent-package/jre /data/docker/bkci/ci/agent-package/packages