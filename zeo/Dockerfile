FROM eeacms/zope:2.8.0

MAINTAINER "Vitalie Maldur" <vitalie.maldur@eaudeweb.ro>

# Path to zeostorage
ENV STORAGE_PATH /var/local/zeostorage

# Create zeo instance
RUN python $ZOPE_PATH/bin/mkzeoinstance.py $STORAGE_PATH
RUN chown -R 500:500 $STORAGE_PATH


ENV ZOPE_USER zope

# Create user=zope with uid=500 gid=500 groups=500
RUN groupadd -g 500 zope
RUN useradd zope -g zope
RUN usermod -u 500 zope

# Add chaperone
RUN yum -y install epel-release
RUN yum install python34 python34-devel -y
RUN curl -s "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py"
RUN python3.4 get-pip.py
RUN cd /usr/bin
RUN ln -s python3.4 python3

# Chaperone install
RUN pip3 install chaperone
RUN mkdir -p /etc/chaperone.d
COPY chaperone.conf /etc/chaperone.d/chaperone.conf

# Clean
RUN yum clean all
RUN rm -rf /tmp/* /var/tmp/*

# Start Chaperone
ENV _CHAP_OPTIONS="--default-home=/var/local/zeostorage"
ENTRYPOINT ["/usr/bin/chaperone"]

# Use user
User zope