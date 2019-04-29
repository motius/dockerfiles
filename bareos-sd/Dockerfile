FROM centos:7.6.1810

ENV REFRESHED_AT="2019-4-29" \
    BAREOS_SD_CONF_FILE=bareos-sd.conf

RUN curl -Ls http://download.bareos.org/bareos/release/18.2/CentOS_7/bareos.repo \
    > /etc/yum.repos.d/bareos.repo \
  && yum -y install \
    bareos-storage \
    openssl \
  && yum clean all

ADD rootfs /

EXPOSE 9103
VOLUME /storage
VOLUME /etc/bareos

CMD ["/init"]
