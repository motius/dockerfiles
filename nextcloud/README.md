## motius/nextcloud
![](https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Nextcloud_Logo.svg/1280px-Nextcloud_Logo.svg.png)

**This image was made and maintained for Motius and we have no intention to make this official. Support won't be regular so if there's an update, or a fix, you can open a pull request. Any contribution is welcome, but please be aware I'm very busy currently. Before opening an issue, please check if there's already one related. Also please use Github instead of Docker Hub, otherwise I won't see your comments. Thanks.**

![](https://img.shields.io/docker/pulls/motius/nextcloud.svg) ![](https://img.shields.io/github/commit-activity/y/motius/dockerfiles.svg) ![](https://img.shields.io/docker/automated/motius/nextcloud.svg) ![](https://img.shields.io/docker/build/motius/nextcloud.svg)
### Features
- Build every night to keep the container up to date
- Based on Alpine Linux 3.7.
- Bundled with nginx and PHP 7.1 (motius/nginx-php image).
- Automatic installation using environment variables.
- Package integrity (SHA512) and authenticity (PGP) checked during building process.
- Data and apps persistence.
- OPCache (opcocde), APCu (local) installed and configured.
- system cron task running.
- MySQL, PostgreSQL (server not built-in) and sqlite3 support.
- Redis, FTP, SMB, LDAP, IMAP support.
- GNU Libiconv for php iconv extension (avoiding errors with some apps).
- No root processes. Never.
- Environment variables provided (see below).

### Tags
- **latest** : latest stable version. (13.0)
- **13.0**: latest 13.0.X version (stable)
- **12.0** : latest 12.0.x version (old stable)
- **11.0** : latest 11.0.x version

For security reasons, you should occasionally update the container, even if you have the latest version of Nextcloud.

### Build-time variables
- **NEXTCLOUD_VERSION** : version of nextcloud
- **GPG_nextcloud** : signing key fingerprint

### Environment variables
- **UID** : nextcloud user id *(default : 991)*
- **GID** : nextcloud group id *(default : 991)*
- **UPLOAD_MAX_SIZE** : maximum upload size *(default : 10G)*
- **APC_SHM_SIZE** : apc memory size *(default : 128M)*
- **OPCACHE_MEM_SIZE** : opcache memory size in megabytes *(default : 128)*
- **MEMORY_LIMIT** : php memory limit *(default : 512M)*
- **CRON_PERIOD** : time interval between two cron tasks *(default : 15m)*
- **CRON_MEMORY_LIMIT** : memory limit for PHP when executing cronjobs *(default : 1024m)*
- **TZ** : the system/log timezone *(default : Etc/UTC)*
- **ADMIN_USER** : username of the admin account *(default : none, web configuration)*
- **ADMIN_PASSWORD** : password of the admin account *(default : none, web configuration)*
- **DOMAIN** : domain to use during the setup *(default : localhost)*
- **DB_TYPE** : database type (sqlite3, mysql or pgsql) *(default : sqlite3)*
- **DB_NAME** : name of database *(default : none)*
- **DB_USER** : username for database *(default : none)*
- **DB_PASSWORD** : password for database user *(default : none)*
- **DB_HOST** : database host *(default : none)*

Don't forget to use a **strong password** for the admin account!

### Port
- **8888** : HTTP Nextcloud port.

### Volumes
- **/data** : Nextcloud data.
- **/config** : config.php location.
- **/apps2** : Nextcloud downloaded apps.
- **/nextcloud/themes** : Nextcloud themes location.
- **/php/session** : php session files.

### Database
Basically, you can use a database instance running on the host or any other machine. An easier solution is to use an external database container. I suggest you to use MariaDB, which is a reliable database server. You can use the official `mariadb` image available on Docker Hub to create a database container, which must be linked to the Nextcloud container. PostgreSQL can also be used.

### Setup
Pull the image and create a container. `/docker` can be anywhere on your host, this is just an example. Change `MYSQL_ROOT_PASSWORD` and `MYSQL_PASSWORD` values (mariadb). You may also want to change UID and GID for Nextcloud, as well as other variables (see *Environment Variables*).

You are **not obliged** to use `ADMIN_USER` and `ADMIN_PASSWORD`. If these variables are not provided, you'll be able to configure your admin acccount from your browser.

Now you have to use a **reverse proxy** in order to access to your container through Internet, steps and details are available at the end of the README.md. And that's it! Since you already configured Nextcloud through setting environment variables, there's no setup page.

### Configure
In the admin panel, you should switch from `AJAX cron` to `cron` (system cron).

### Update
Pull a newer image, then recreate the container as you did before (*Setup* step). None of your data will be lost since you're using external volumes. If Nextcloud performed a full upgrade, your apps could be disabled, enable them again **(starting with 12.0.x, your apps are automatically enabled after an upgrade)**.

### Docker-compose
I advise you to use [docker-compose](https://docs.docker.com/compose/), which is a great tool for managing containers. You can create a `docker-compose.yml` with the following content (which must be adapted to your needs) and then run `docker-compose up -d nextcloud-db`, wait some 15 seconds for the database to come up, then run everything with `docker-compose up -d`, that's it! On subsequent runs,  a single `docker-compose up -d` is sufficient!

#### Docker-compose file
Don't copy/paste without thinking! It is a model so you can see how to do it correctly.

```
version: '3'

services:
  nextcloud:
    image: motius/nextcloud:13.0.4
    depends_on:
      - nextcloud-db           # If using MySQL
      - solr                   # If using Nextant
      - redis                  # If using Redis
    environment:
      - "UID=1000"
      - "GID=1000"
      - "UPLOAD_MAX_SIZE=10G"
      - "APC_SHM_SIZE=128M"
      - "OPCACHE_MEM_SIZE=128"
      - "CRON_PERIOD=15m"
      - "TZ=Europe/Berlin"
      - "ADMIN_USER=admin"            # Don't set to configure through browser
      - "ADMIN_PASSWORD=admin"        # Don't set to configure through browser
      - "DOMAIN=localhost"
      - "DB_TYPE=mysql"
      - "DB_NAME=nextcloud"
      - "DB_USER=nextcloud"
      - "DB_PASSWORD=supersecretpassword"
      - "DB_HOST=nextcloud-db"
    volumes:
      - ./data:/data
      - ./config:/config
      - ./apps:/apps2
      - ./themes:/nextcloud/themes
    networks:
      - nextcloud
    ports:
      - 80:8888

  # If using MySQL
  nextcloud-db:
    image: mariadb:10
    volumes:
      - ./db:/var/lib/mysql
    environment:
      - "MYSQL_ROOT_PASSWORD=supersecretpassword"
      - "MYSQL_DATABASE=nextcloud"
      - "MYSQL_USER=nextcloud"
      - "MYSQL_PASSWORD=supersecretpassword"
    networks:
      - nextcloud

  # If using Nextant
  solr:
    image: solr:alpine
    container_name: solr
    volumes:
      - ./solr:/opt/solr/server/solr/mycores/nextant
    entrypoint:
      - docker-entrypoint.sh
      - solr-precreate
      - nextant
    networks:
      - nextcloud

  # If using Redis
  redis:
    image: redis:alpine
    container_name: redis
    volumes:
      - ./redis:/data
    networks:
      - nextcloud

networks:
  nextcloud:
  default:
    driver: bridge
```

You can update everything with `docker-compose pull` followed by `docker-compose up -d`.

### How to configure Redis
Redis can be used for distributed and file locking cache, alongside with APCu (local cache), thus making Nextcloud even more faster. As PHP redis extension is already included, all you have to is to deploy a redis server (you can do as above with docker-compose) and bind it to nextcloud in your config.php file :

```
'memcache.distributed' => '\OC\Memcache\Redis',
'memcache.locking' => '\OC\Memcache\Redis',
'memcache.local' => '\OC\Memcache\APCu',
'redis' => array(
   'host' => 'redis',
   'port' => 6379,
   ),
```

### How to configure Nextant
You will have to deploy a Solr server, I've shown an example above with docker-compose. Once Nextant app is installed, go to "additional settings" in your admin pannel and use http://solr:8983/solr as "Adress of your Solr Servlet". There you go!

### Tip : how to use occ command
There is a script for that, so you shouldn't bother to log into the container, set the right permissions, and so on. Just use `docker-compose exec nextcloud occ command`.

### Reverse proxy
Of course you can use your own solution! nginx, Haproxy, Caddy, h2o, Traefik...

Whatever your choice is, you have to know that headers are already sent by the container, including HSTS, so there's no need to add them again. **It is strongly recommended (I'd like to say : MANDATORY) to use Nextcloud through an encrypted connection (HTTPS).** [Let's Encrypt](https://letsencrypt.org/) provides free SSL/TLS certificates, so you have no excuses.

That's it! Did I lie to you?
