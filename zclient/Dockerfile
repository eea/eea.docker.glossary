FROM eeacms/zope:2.8.0

MAINTAINER "Vitalie Maldur" <vitalie.maldur@eaudeweb.ro>

# Path to zope instance
ENV ZOPE_INSTANCE /var/local/zclient
ENV ZOPE_USER zope

# Create user with uid=500 gid=500 groups=500
RUN groupadd -g 500 zope
RUN useradd zope -g zope
RUN usermod -u 500 zope

# Create zope instance
RUN python $ZOPE_PATH/bin/mkzopeinstance.py -d $ZOPE_INSTANCE -u $ZOPE_USER:$ZOPE_USER
RUN touch $ZOPE_INSTANCE/log/event.log

# Configuration
RUN chown -R zope:zope $ZOPE_INSTANCE
COPY zope.conf $ZOPE_INSTANCE/etc/zope.conf

# Adding application code
## install dependencies
RUN yum -y updateinfo && yum -y install subversion

## install pygoogle
RUN wget https://pypi.python.org/packages/source/p/pygoogle/pygoogle-0.6.tar.gz && \
    tar xvf pygoogle-0.6.tar.gz && \
    cd pygoogle-0.6/ && python2.3 setup.py install && cd ..

## install itools-0.9.5
RUN yum -y install unzip && \
    wget https://github.com/hforge/itools/archive/0.9.5.zip -O itools-0.9.5.zip && \
    unzip itools-0.9.5.zip && \
    echo "Revision: \n Version 1.0.0" > itools-0.9.5/Changelog && \
    cd itools-0.9.5/ && python2.3 setup.py install && cd ..

#clean up
RUN rm -rf pygoogle-0.6* itools-0.9.5* && yum clean all

USER 500

## get the application code
RUN svn co https://svn.eionet.europa.eu/repositories/Zope/trunk/ALiSS_agents/ALiSS/ $ZOPE_INSTANCE/Products/ALiSS && \
    svn co https://svn.eionet.europa.eu/repositories/Zope/trunk/ALiSS_agents/EEAALiSS/ $ZOPE_INSTANCE/Products/EEAALiSS && \
    svn co https://svn.eionet.europa.eu/repositories/Zope/trunk/ALiSS_agents/Localizer/ $ZOPE_INSTANCE/Products/Localizer && \
    svn co https://svn.eionet.europa.eu/repositories/Zope/trunk/ALiSS_agents/iHotfix/ $ZOPE_INSTANCE/Products/iHotfix && \
    svn co https://svn.eionet.europa.eu/repositories/Zope/trunk/ALiSS_agents/Five/ $ZOPE_INSTANCE/Products/Five && \
    svn co https://svn.eionet.europa.eu/repositories/Zope/trunk/ALiSS_agents/Epoz/ $ZOPE_INSTANCE/Products/Epoz && \
    svn co https://svn.eionet.europa.eu/repositories/Zope/trunk/ALiSS_agents/Extensions/ $ZOPE_INSTANCE/Extensions && \
    svn co https://svn.eionet.europa.eu/repositories/Zope/trunk/EEAGlossary/ $ZOPE_INSTANCE/Products/EEAGlossary

RUN mkdir -p $ZOPE_INSTANCE/var/ALiSS && cp $ZOPE_INSTANCE/Products/ALiSS/data/aliss_stopwords.xliff $ZOPE_INSTANCE/var/ALiSS


##### Install Chaperone
USER root

# Python 3.4 install
RUN yum -y install epel-release
RUN yum install python34 python34-devel -y
RUN curl -s "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
RUN python3.4 get-pip.py

# Set symlink
RUN cd /usr/bin
RUN ln -s python3.4 python3

# Chaperone install
RUN pip3 install chaperone
RUN mkdir -p /etc/chaperone.d
COPY chaperone.conf /etc/chaperone.d/chaperone.conf

# Clean
RUN yum clean all
RUN rm -rf /tmp/* /var/tmp/*

# Chaperone
ENV _CHAP_OPTIONS="--default-home /var/local/zclient/"
ENTRYPOINT ["/usr/bin/chaperone"]

# Run container with user
USER zope
