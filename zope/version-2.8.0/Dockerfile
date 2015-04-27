FROM centos:centos7

MAINTAINER Vitalie Maldur <vitalie.maldur@eaudeweb.ro>

RUN yum -y update && yum -y install \
    wget \
    make \
    gcc \
    gcc-c++ \
    tar

# Zlib install
ENV ZLIB_VERSION 1.2.8

RUN wget http://zlib.net/zlib-$ZLIB_VERSION.tar.gz && \
    tar -xvf zlib-$ZLIB_VERSION.tar.gz && \
    cd zlib-$ZLIB_VERSION && ./configure && make && make install

# Python install
ENV PYTHON_VERSION 2.3.5

RUN wget https://www.python.org/ftp/python/$PYTHON_VERSION/Python-$PYTHON_VERSION.tgz && \
    tar -xvf Python-$PYTHON_VERSION.tgz && \
    cd Python-$PYTHON_VERSION && ./configure && make && make install

# Zope installation
ENV ZOPE_VERSION 2.8.0
ENV ZOPE_PATH /var/local

RUN wget http://old.zope.org/Products/Zope/2.8.0/Zope-$ZOPE_VERSION-final.tar.gz && \
    tar -xvf Zope-$ZOPE_VERSION-final.tar.gz && \
    cd Zope-$ZOPE_VERSION-final && ./configure --prefix=$ZOPE_PATH && make install

# Clean up
RUN yum clean all && rm -r zlib-$ZLIB_VERSION zlib-$ZLIB_VERSION.tar.gz \
  Python-$PYTHON_VERSION Python-$PYTHON_VERSION.tgz \
  Zope-$ZOPE_VERSION-final Zope-$ZOPE_VERSION-final.tar.gz
