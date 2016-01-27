#base image
FROM centos:6

#author
MAINTAINER Norman 332535694@qq.com

WORKDIR /
COPY Centos-6.repo Centos-6.repo
ADD https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tar.xz Python-2.7.11.tar.xz
COPY get-pip.py get-pip.py
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup && \
    mv Centos-6.repo /etc/yum.repos.d/CentOS-Base.repo && \
    yum clean all && yum makecache && \
    yum groupinstall -y "Chinese Support" && \
    yum groupinstall -y Fonts && \
    yum install -y zlib-devel freetype-devel fontconfig-devel && \
    yum -y install wget unzip tar zlib-devel bzip2 bzip2-devel libjpeg-devel libpng-devel && \
    yum -y install xz openssl openssl-devel gcc gcc-c++ cmake git && \
    unxz Python-2.7.11.tar.xz && tar -xf Python-2.7.11.tar
WORKDIR /Python-2.7.11
RUN ./configure CFLAGS=-fPIC && make all && make install && make clean && make distclean
WORKDIR /
RUN python get-pip.py && \
    pip install supervisor && \
    echo_supervisord_conf > /etc/supervisord.conf && \
    echo "[include]" >> /etc/supervisord.conf
RUN rm -rf Python-2.7.11 && rm -f Python-2.7.11.tar.xz && rm -f Python-2.7.11.tar