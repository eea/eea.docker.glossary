## EEA Glossary application docker setup

ZEO client ready to run Docker image for EEA Glossary project.

### Dockerhub repository
- [hub.docker.com](https://registry.hub.docker.com/u/eeacms/glossary-zclient/)

### Installation
1. Install [Docker](https://www.docker.com/).
2. Install [Docker Compose](https://docs.docker.com/compose/).

### Usage

    $ git clone https://github.com/eea/eea.docker.glossary
    $ cd eea.docker.glossary
    $ docker-compose -f docker-compose-dev.yml up

After all containers are started, you can access the application on **http://\<IP\>**, where **IP** is address of your machine.

### Restore application data
If you have a Data.fs file for EEA Glossary application, you can add it with the following commands:

    $ git clone https://github.com/eea/eea.docker.glossary
    $ cd eea.docker.glossary
    $ docker-compose up data
    $ docker run -it --rm --volumes-from eeadockerglossary_data_1 -v \ 
      /path/to/parent/folder/of/Data.fs/file/:/mnt debian /bin/bash -c \ 
      "cp /mnt/Data.fs /var/local/zeostorage/var/ && chown 1000:1000 /var/local/zeostorage/var/Data.fs"
