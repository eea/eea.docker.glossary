FROM busybox

MAINTAINER "Vitalie Maldur" <vitalie.maldur@eaudeweb.ro>

ENV VOLUME_PATH /var/local/zeostorage/var/
RUN mkdir -p $VOLUME_PATH
RUN chown -R 1000:1000 $VOLUME_PATH
VOLUME $VOLUME_PATH

USER 1000
