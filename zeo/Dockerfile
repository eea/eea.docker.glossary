FROM eeacms/zope:2.8.0

MAINTAINER "Vitalie Maldur" <vitalie.maldur@eaudeweb.ro>

# Path to zeostorage
ENV STORAGE_PATH /var/local/zeostorage

# Create zeo instance
RUN python $ZOPE_PATH/bin/mkzeoinstance.py $STORAGE_PATH
RUN chown -R 1000:1000 $STORAGE_PATH

# Run zeoserver
CMD $STORAGE_PATH/bin/zeoctl start && $STORAGE_PATH/bin/zeoctl logtail
