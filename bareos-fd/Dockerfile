FROM centos:7.6.1810

ENV REFRESHED_AT="2019-4-29" \
    BAREOS_FD_CONF_FILE=bareos-fd.conf

RUN curl -Ls http://download.bareos.org/bareos/release/18.2/CentOS_7/bareos.repo \
    > /etc/yum.repos.d/bareos.repo \
  && yum -y localinstall http://yum.postgresql.org/9.4/redhat/rhel-6-x86_64/pgdg-centos94-9.4-1.noarch.rpm  \
  && yum -y install \
    git \
    openssl \
    ca-certificates \
    bareos-client \
    postgresql95 \
    sshfs \
    cifs-utils \
    openssl \
    bzip2 \
  && yum clean all

ADD rootfs /

EXPOSE 9102
VOLUME /etc/bareos

CMD ["/init"]
