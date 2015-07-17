FROM       eeacms/varnish:latest
MAINTAINER "Vitalie Maldur" <vitalie.maldur@eaudeweb.ro>

RUN        yum -y updateinfo && yum -y install subversion
RUN        mkdir -p /var/static/ && \
           svn export https://svn.eionet.europa.eu/repositories/Zope/trunk/www.eea.europa.eu/trunk/static/500msg.html /var/static/500msg.html
