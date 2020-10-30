## bkci基础linux镜像

FROM centos:centos7.2.1511

LABEL maintainer="blueking"

## 使用自己的yum源加速
COPY linux/CentOS-Base.repo /etc/yum.repos.d/

RUN yum clean all &&\
    yum update -y &&\
    yum -y install kde-l10n-Chinese telnet &&\
    yum -y reinstall glibc-common &&\
    yum clean all  &&\
    localedef -c -f UTF-8 -i zh_CN zh_CN.utf8  && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
    rpm --rebuilddb && \
    yum install -y git net-tools svn gcc-c++ cmake ncurses-devel zlib* dos2unix cppunit-devel cppunit-devel clang bzip2 wget initscripts sysstat

ENV LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN:zh \
    LC_ALL=zh_CN.UTF-8