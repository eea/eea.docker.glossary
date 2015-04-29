FROM eeacms/zope:2.8.0

MAINTAINER "Vitalie Maldur" <vitalie.maldur@eaudeweb.ro>

# Path to zope instance
ENV ZOPE_INSTANCE /var/local/zclient
ENV ZOPE_USER zope

# Add the zope user
RUN useradd -u 1000 -m -s /bin/bash $ZOPE_USER

# Create zope instance
RUN python $ZOPE_PATH/bin/mkzopeinstance.py -d $ZOPE_INSTANCE -u $ZOPE_USER:$ZOPE_USER
RUN touch $ZOPE_INSTANCE/log/event.log

# Configuration
RUN chown -R 1000:1000 $ZOPE_INSTANCE
COPY zope.conf $ZOPE_INSTANCE/etc/zope.conf

# Adding application code
## install dependencies
RUN yum -y update && yum -y install subversion

## install pygoogle
RUN wget https://pypi.python.org/packages/source/p/pygoogle/pygoogle-0.6.tar.gz && \
    tar xvf pygoogle-0.6.tar.gz && \
    cd pygoogle-0.6/ && python2.3 setup.py install && cd ..

## install itools-0.9.5
RUN wget http://download.hforge.org/itools/0.9/itools-0.9.5.tar.gz && \
    tar xvf itools-0.9.5.tar.gz && \
    echo "Revision: \n Version 1.0.0" > itools-0.9.5/Changelog && \
    cd itools-0.9.5/ && python2.3 setup.py install && cd ..

#clean up
RUN rm -rf pygoogle-0.6* itools-0.9.5* && yum clean all

USER 1000

## get the application code
RUN svn co https://svn.eionet.europa.eu/repositories/Zope/trunk/ALiSS_agents/ALiSS/ $ZOPE_INSTANCE/Products/ALiSS && \
    svn co https://svn.eionet.europa.eu/repositories/Zope/trunk/ALiSS_agents/EEAALiSS/ $ZOPE_INSTANCE/Products/EEAALiSS && \
    svn co https://svn.eionet.europa.eu/repositories/Zope/trunk/ALiSS_agents/Localizer/ $ZOPE_INSTANCE/Products/Localizer && \
    svn co https://svn.eionet.europa.eu/repositories/Zope/trunk/ALiSS_agents/iHotfix/ $ZOPE_INSTANCE/Products/iHotfix && \
    svn co https://svn.eionet.europa.eu/repositories/Zope/trunk/ALiSS_agents/Five/ $ZOPE_INSTANCE/Products/Five && \
    svn co https://svn.eionet.europa.eu/repositories/Zope/trunk/ALiSS_agents/Epoz/ $ZOPE_INSTANCE/Products/Epoz && \
    svn co https://svn.eionet.europa.eu/repositories/Zope/trunk/ALiSS_agents/Extensions/ $ZOPE_INSTANCE/Extensions

RUN mkdir -p $ZOPE_INSTANCE/var/ALiSS && cp $ZOPE_INSTANCE/Products/ALiSS/data/aliss_stopwords.xliff $ZOPE_INSTANCE/var/ALiSS

# Run zope
CMD $ZOPE_INSTANCE/bin/zopectl start && $ZOPE_INSTANCE/bin/zopectl logtail
