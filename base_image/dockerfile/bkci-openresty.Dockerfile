FROM bkci/linux

LABEL maintainer="blueking"

RUN wget https://openresty.org/package/centos/7/x86_64/openresty-openssl-1.1.0h-3.el7.centos.x86_64.rpm &&\
    wget https://openresty.org/package/centos/7/x86_64/openresty-pcre-8.42-1.el7.centos.x86_64.rpm &&\
    wget https://openresty.org/package/centos/7/x86_64/openresty-zlib-1.2.11-3.el7.centos.x86_64.rpm &&\
    wget https://openresty.org/package/centos/7/x86_64/openresty-1.13.6.2-1.el7.centos.x86_64.rpm

RUN chmod 644 openresty-1.13.6.2-1.el7.centos.x86_64.rpm &&\
    chmod 644 openresty-openssl-1.1.0h-3.el7.centos.x86_64.rpm &&\
    chmod 644 openresty-pcre-8.42-1.el7.centos.x86_64.rpm &&\
    chmod 644 openresty-zlib-1.2.11-3.el7.centos.x86_64.rpm

RUN rpm -ivh openresty-pcre-8.42-1.el7.centos.x86_64.rpm  &&\
    rpm -ivh openresty-zlib-1.2.11-3.el7.centos.x86_64.rpm  &&\
    rpm -ivh openresty-openssl-1.1.0h-3.el7.centos.x86_64.rpm  --replacefiles &&\
    rpm -ivh openresty-1.13.6.2-1.el7.centos.x86_64.rpm