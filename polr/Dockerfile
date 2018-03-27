FROM alpine:3.7

ARG NGINX_VER=1.13.9
ARG PHP_VER=7.1.14
ARG POLR_VER=2.2.0

LABEL description="Polr bundled with nginx and php based on Alpine" \
      maintainer="Motius <info@motius.de>" \
      php_version="PHP v$PHP_VER built from source" \
      nginx_version="nginx v$NGINX_VER built from source"\
      polr_version="polr v$POLR_VER"

ARG PHP_MIRROR=http://ch1.php.net
ARG GPG_PHP="1729 F839 38DA 44E2 7BA0  F4D3 DBDB 3974 70D1 2172"
ARG NGINX_CONF=" \
    --prefix=/nginx \
    --sbin-path=/usr/local/sbin/nginx \
    --http-log-path=/nginx/logs/access.log \
    --error-log-path=/nginx/logs/error.log \
    --pid-path=/nginx/run/nginx.pid \
    --lock-path=/nginx/run/nginx.lock \
    --with-threads \
    --with-file-aio \
    --without-http_geo_module \
    --without-http_autoindex_module \
    --without-http_split_clients_module \
    --without-http_memcached_module \
    --without-http_empty_gif_module \
    --without-http_browser_module"

ARG PHP_CONF=" \
    --prefix=/usr \
    --libdir=/usr/lib/php \
    --datadir=/usr/share/php \
    --sysconfdir=/php/etc \
    --localstatedir=/php/var \
    --with-pear=/usr/share/php \
    --with-config-file-scan-dir=/php/conf.d \
    --with-config-file-path=/php \
    --with-pic \
    --disable-short-tags \
    --without-readline \
    --enable-bcmath=shared \
    --enable-fpm \
    --disable-cgi \
    --enable-mysqlnd \
    --enable-mbstring \
    --with-curl \
    --with-libedit \
    --with-openssl \
    --with-xpm-dir=no \
    --with-freetype-dir \
    --with-zlib"

ARG PHP_EXT_LIST=" \
    mbstring \
    mysqli \
    openssl \
    pdo_mysql \
    sqlite3 \
    pdo_sqlite \
    tokenizer \
    json \
    curl"

COPY rootfs /

RUN NB_CORES=${BUILD_CORES-$(getconf _NPROCESSORS_CONF)} \
### Packages installation
 && BUILD_DEPS=" \
    re2c \
    bison \
    file \
    linux-headers \
    libtool \
    build-base \
    pcre-dev \
    zlib-dev \
    wget \
    gnupg \
    autoconf \
    gcc \
    g++ \
    libc-dev \
    make \
    pkgconf \
    curl-dev \
    ca-certificates \
    freetype-dev \
    libmcrypt-dev \
    icu-dev \
    libxpm-dev \
    libedit-dev \
    libxml2-dev \
    libressl-dev \
    sqlite-dev" \
 && apk update && apk -U add \
    ${BUILD_DEPS} \
    s6 \
    su-exec \
    curl \
    libedit \
    libxml2 \
    libressl \
    pcre \
    zlib \
    ${CUSTOM_PKGS} \
### Source downloading
 && wget http://nginx.org/download/nginx-${NGINX_VER}.tar.gz -O /tmp/nginx-${NGINX_VER}.tar.gz \
 && wget http://nginx.org/download/nginx-${NGINX_VER}.tar.gz.asc -O /tmp/nginx-${NGINX_VER}.tar.gz.asc \
 && wget http://nginx.org/keys/mdounin.key -O /tmp/nginx_signing.key \
 && wget ${PHP_MIRROR}/get/php-${PHP_VER}.tar.gz/from/this/mirror -O /tmp/php-${PHP_VER}.tar.gz \
 && wget ${PHP_MIRROR}/get/php-${PHP_VER}.tar.gz.asc/from/this/mirror -O /tmp/php-${PHP_VER}.tar.gz.asc \
 && wget https://github.com/cydrobolt/polr/archive/${POLR_VER}.tar.gz \
### Validation
 && gpg --import /tmp/nginx_signing.key \
 && FINGERPRINT="$(LANG=C gpg --verify /tmp/nginx-${NGINX_VER}.tar.gz.asc /tmp/nginx-${NGINX_VER}.tar.gz 2>&1 \
  | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
 && if [ -z "${FINGERPRINT}" ]; then echo "Warning! Invalid GPG signature!" && exit 1; fi \
 && gpg --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys "${GPG_PHP}" \
 && FINGERPRINT="$(LANG=C gpg --verify /tmp/php-${PHP_VER}.tar.gz.asc /tmp/php-${PHP_VER}.tar.gz 2>&1 \
  | sed -n "s#Primary key fingerprint: \(.*\)#\1#p")" \
 && if [ -z "${FINGERPRINT}" ]; then echo "Warning! Invalid GPG signature!" && exit 1; fi \
#### Extraction
 && mkdir -p /php/conf.d /usr/src \
 && tar xzf /tmp/nginx-${NGINX_VER}.tar.gz -C /usr/src \
 && tar xzvf /tmp/php-${PHP_VER}.tar.gz -C /usr/src \
 && tar -xf ${POLR_VER}.tar.gz \
 && mv polr-${POLR_VER} polr \
 && rm ${POLR_VER}.tar.gz \
### nginx installation
 && cd /usr/src/nginx-${NGINX_VER} \
 && ./configure --with-cc-opt="-O3 -fPIE -fstack-protector-strong" ${NGINX_CONF} \
 && make -j ${NB_CORES} \
 && make install \
### PHP installation
 && mv /usr/src/php-${PHP_VER} /usr/src/php \
 && cd /usr/src/php \
 && ./configure CFLAGS="-O3 -fstack-protector-strong" ${PHP_CONF} \
 && make -j ${NB_CORES} \
 && make install \
### Strip, clean, install modules
 && { find /usr/local/bin /usr/local/sbin -type f -perm +0111 -exec strip --strip-all '{}' + || true; } \
 && make clean \
### Polr installation
 && cd /polr/ \
 && curl -sS https://getcomposer.org/installer | php \
 && php composer.phar install --no-dev -o \
 && chmod u+x /usr/local/bin/* /etc/s6.d/*/* \
 && docker-php-ext-install ${PHP_EXT_LIST} \
 && apk del ${BUILD_DEPS} \
 && rm -rf /tmp/* /var/cache/apk/* /usr/src/* \
    /usr/local/bin/docker-php-ext-configure \
    /usr/local/bin/docker-php-ext-enable \
    /usr/local/bin/docker-php-ext-install \
 && mkdir -p /nginx/logs /nginx/run /php/php-fpm.d /php/logs /php/run /php/session \
 && adduser -DH www-data

COPY patches /
EXPOSE 8888
CMD ["run.sh"]
