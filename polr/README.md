# Polr
![](https://github.com/cydrobolt/polr/raw/master/public/img/logo.png)

**This image was made and maintained for Motius and we have no intention to make this official. Support won't be regular so if there's an update, or a fix, you can open a pull request. Any contribution is welcome, but please be aware I'm very busy currently. Before opening an issue, please check if there's already one related. Also please use Github instead of Docker Hub, otherwise I won't see your comments. Thanks.**

![](https://img.shields.io/docker/pulls/motius/polr.svg) ![](https://img.shields.io/github/commit-activity/y/motius/dockerfiles.svg) ![](https://img.shields.io/docker/automated/motius/polr.svg) ![](https://img.shields.io/docker/build/motius/polr.svg) ![](https://circleci.com/gh/motius/dockerfiles/tree/master.svg?style=shield)

### Features
- Based on Alpine Linux 3.7.
- Bundled with nginx and PHP 7.1.
- Package integrity (SHA512) and authenticity (PGP) checked during building process.
- MySQL and sqlite3 support.
- No root processes. Never

### Tags
- **latest** : latest stable version. (2.2.0)
- **2.2.0** : latest 2.2.0 version

### Docker-compose
I advise you to use [docker-compose](https://docs.docker.com/compose/), which is a great tool for managing containers. You can create a `docker-compose.yml` with the following content (which must be adapted to your needs) and then run `docker-compose up -d nextcloud-db`, wait some 15 seconds for the database to come up, then run everything with `docker-compose up -d`, that's it! On subsequent runs,  a single `docker-compose up -d` is sufficient!

#### Docker-compose file
Don't copy/paste without thinking! It is a model so you can see how to do it correctly.

```
version: "3"
services:
  db:
    image: mariadb:10
    volumes:
      - ./db:/var/lib/mysql
    environment:
      - "MYSQL_ROOT_PASSWORD=supersecretpassword"
      - "MYSQL_DATABASE=polr"
      - "MYSQL_USER=polr"
      - "MYSQL_PASSWORD=supersecretpassword"

  polr:
    container_name: polr
    image: motius/polr:2.2.0
    ports:
      - 8888:8888
    restart: always

```

### Configuration
Check the polr documentation [link](https://github.com/cydrobolt/polr/blob/master/docs/user-guide/installation.md) on how to install the system once `docker-compose up -d` was executed

### TODO
- [ ] Add upgrade mechanism
- [ ] Add environment variables for configuration
- [ ] Add persistence for configuration
- [ ] Add volumes