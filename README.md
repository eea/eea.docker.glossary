## EEA Glossary application docker setup

Docker images created for EEA Glossary, including images for **ZEO server**, **ZEO client**, **Varnish** and a dedicated data container.

**ZEO server** and **ZEO client** have the same base image, you can find it on [Docker Hub](https://registry.hub.docker.com/u/eeacms/zope/) or you can inspect the [Github repository](https://github.com/eea/eea.docker.zope) to see the Dockerfile.


### Installation
1. Install [Docker](https://www.docker.com/).
2. Install [Docker Compose](https://docs.docker.com/compose/).

### Usage
  
    $ git clone https://github.com/eea/eea.docker.glossary
    $ cd eea.docker.glossary
    $ docker-compose up

### Restore application data
If you have a Data.fs file for EEA Glossary application, you can add it with the following commands:

    $ docker-compose up data
    $ docker run -it --rm --volumes-from dockerglossary_data_1 -v \ 
      /path/to/parent/folder/of/Data.fs/file/:/mnt debian /bin/bash -c \ 
      "cp /mnt/Data.fs /var/local/zeostorage/var/ && chown 1000:1000 /var/local/zeostorage/var/Data.fs"
