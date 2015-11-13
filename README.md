## EEA Glossary application docker setup

Docker images created for EEA Glossary, including images for **ZEO server**, **ZEO client**, **Varnish** and a dedicated data container.

**ZEO server** and **ZEO client** have the same base image, you can find it on [Docker Hub](https://registry.hub.docker.com/u/eeacms/zope/) or you can inspect the [Github repository](https://github.com/eea/eea.docker.zope) to see the Dockerfile.


### Installation
1. Install [Docker](https://www.docker.com/).
2. Install [Docker Compose](https://docs.docker.com/compose/).

### Usage

Production environment:

    $ git clone https://github.com/eea/eea.docker.glossary
    $ cd eea.docker.glossary
    $ docker-compose up -d

Development environment:

    $ git clone https://github.com/eea/eea.docker.glossary
    $ cd eea.docker.glossary
    $ docker-compose -f docker-compose-dev.yml up

After all containers are started, you can access the application on **http://\<IP\>**, where **IP** is address of your machine.

### Upgrade

    $ cd eea.docker.glossary
    $ git pull
    $ docker-compose pull

    $ docker-compose stop
    $ docker-compose rm -v apache varnish zclient1 zclient2 zclient3 zeo
    $ docker-compose up -d --no-recreate

### Restore application data
If you have a Data.fs file for EEA Glossary application, you can add it with the following commands:

    $ docker-compose up data
    $ docker run -it --rm --volumes-from eeadockerglossary_data_1 -v \
      /path/to/parent/folder/of/Data.fs/file/:/mnt debian /bin/bash -c \
      "cp /mnt/Data.fs /var/local/zeostorage/var/ && chown 1000:1000 /var/local/zeostorage/var/Data.fs"

### Data migration
You can access production Data.fs on Sparrow, it is located at:

    /var/local/zope-instances/eeawebservices/eeawebservices-zeo-storage/var/Data.fs
