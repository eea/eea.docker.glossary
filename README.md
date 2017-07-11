## EEA Glossary application docker setup

**DEPRECATED**: the glossary is now available in plone via [EEA glossary online](https://www.eea.europa.eu/help/glossary) see dexterity product [eea.glossary](https://github.com/eea/eea.glossary).

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

After all containers are started, you can access the application on **http://\<IP\>**, where **IP** is address of your machine.

### Upgrade

    $ cd eea.docker.glossary
    $ git pull
    $ docker-compose pull

    $ docker-compose stop
    $ docker-compose rm -v apache varnish zclient1 zclient2 zclient3 zeo
    $ docker-compose up -d --no-recreate

### Restore application data

1. Start **rsync client** on host where do you want to migrate eggrepo data (DESTINATION HOST):

  ```
    $ docker-compose up data
    $ docker run -it --rm --name=r-client --volumes-from=eeadockerglossary_data_1 eeacms/rsync sh
  ```

2. Start **rsync server** on host from where do you want to migrate eggrepo data (SOURCE HOST):

  ```
    $ docker run -it --rm --name=r-server -p 2224:22 --volumes-from=eeadockerglossary_data_1 \
                 -e SSH_AUTH_KEY="<SSH-KEY-FROM-R-CLIENT-ABOVE>" \
             eeacms/rsync server
  ```

3. Within **rsync client** container from step 1 run:

  ```
    $ rsync -e 'ssh -p 2224' -avz root@<SOURCE HOST IP>:/var/local/zeostorage/var/ /var/local/zeostorage/var/
  ```



