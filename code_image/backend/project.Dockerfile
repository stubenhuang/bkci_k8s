FROM bkci/jdk

LABEL maintainer="blueking"

ENV module project

COPY boot-project.jar /data/docker/bkci/ci/backend/
COPY module_run.sh /data/docker/bkci/ci/backend/
COPY classpath /data/docker/bkci/ci/backend/classpath
COPY bootstrap /data/docker/bkci/ci/backend/bootstrap
COPY font /usr/share/fonts/chinese

RUN rpm --rebuilddb \
    &&yum -y install fontconfig ttmkfdir \
    && chmod -R 755 /usr/share/fonts/chinese \
    && ttmkfdir -e /usr/share/X11/fonts/encodings/encodings.dir \
    && fc-cache
RUN chmod +x /data/docker/bkci/ci/backend/module_run.sh