# BareOS File Deamon
![](https://www.bareos.com/files/Logos/Bareos/Logo_gesamt.png)

**This image was made and maintained for Motius and we have no intention to make this official. Support won't be regular so if there's an update, or a fix, you can open a pull request. Any contribution is welcome, but please be aware I'm very busy currently. Before opening an issue, please check if there's already one related. Also please use Github instead of Docker Hub, otherwise I won't see your comments. Thanks.**

![](https://img.shields.io/docker/pulls/motius/bareos-fd.svg) ![](https://img.shields.io/github/commit-activity/y/motius/dockerfiles.svg) ![](https://img.shields.io/docker/automated/motius/bareos-fd.svg) ![](https://img.shields.io/docker/build/motius/bareos-fd.svg) ![](https://circleci.com/gh/motius/dockerfiles/tree/master.svg?style=shield)



Checkout [motius/bareos-dir](https://hub.docker.com/r/motius/bareos-dir/) for instructions and a docker-compose.yml
### Tags
- **latest** : latest stable version. (17.2)
- **17.2** : latest 17.2 version
- **16.2** : latest 16.2 version

### Environment variables
- **TIMEZONE** Configures the timezone e.g. *Europe/Berlin*

### Volumes
- **/etc/bareos** The configuration folder
- **/tmp/bareos-restores** The location the restores are put

### Configuration
This will create a sample configuration for Bareos using the templates given:
- bareos-fd: [Sample files](https://github.com/motius/dockerfiles/tree/master/bareos-fd/rootfs/temp) mount to `/etc/bareos`