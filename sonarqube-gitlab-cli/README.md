## motius/sonarqube-gitlab-cli
![](https://images.g2crowd.com/uploads/product/image/social_landscape/social_landscape_1489701790/sonarqube.jpg)

**This image was made and maintained for Motius and we have no intention to make this official. Support won't be regular so if there's an update, or a fix, you can open a pull request. Any contribution is welcome, but please be aware I'm very busy currently. Before opening an issue, please check if there's already one related. Also please use Github instead of Docker Hub, otherwise I won't see your comments. Thanks.**

[](https://img.shields.io/docker/pulls/motius/sonarqube-gitlab-cli.svg) ![](https://img.shields.io/github/commit-activity/y/motius/dockerfiles.svg) ![](https://img.shields.io/docker/automated/motius/sonarqube-gitlab-cli.svg) ![](https://img.shields.io/docker/build/motius/sonarqube-gitlab-cli.svg) ![](https://circleci.com/gh/motius/dockerfiles/tree/master.svg?style=shield)

### Features
- Based on Debian Slim
- Package Authenticity (PGP) checked during building process.
- No root processes. Never.
- Environment variables provided (see below).

### Tags
- **latest** : latest stable version

### Important Build-time variables
- **SONARQUBE_VERSION** : version of sonarqube cli
- **GPG_SONARQUBE** : signing key fingerprint
- **BUILD_DEPS**: Dependencies for building the image (deleted after build)
- **DEPS**: Runtime dependencies

### Environment variables
- **URL**: The sonarqube server, format: https://sonarqube.xyz
- **PROJECT_KEY**: Should be set to `CI_PROJECT_ID`
- **PROJECT_NAME**: Should be set to `CI_PROJECT_NAME`
- **USER**: This is the username for sonarqube
- **PASSWORD**: This is the password for sonarqube
- **VERSION**: Used for the version in sonarqube (default: 1.0)
- **MAIN_BRANCH**: The branch used to analyse for the webinterface
- **CI_BUILD_REF**: Set this to `CI_BUILD_REF`
- **CI_BUILD_REF_NAME**: Set this to `CI_BUILD_REF_NAME`
- **CI_PROJECT_ID**: Set this to `CI_PROJECT_ID`
- **CUSTOM_PARAMS**: Those params will be appended to the sonarqube cli
- **GID**: This needs to be set to correct permissions after execution (default: 1000)
- **UID**: This needs to be set to correct permissions after execution (default: 1000)

### Volumes / Working Directory
- **/build**: Mount the sources to this directory

#### Docker-compose file
Don't copy/paste without thinking! It is a model so you can see how to do it correctly.

```
version: '3'
  sonarqube:
    image: motius/sonarqube-gitlab-cli
    volumes:
      - sources:/build
    environment:
      - "URL=https://sonarqube.xyz"
      - "PROJECT_KEY=$CI_PROJECT_KEY"
      - "PROJECT_NAME=$CI_PROJECT_NAME"
      - "USER=username"
      - "PASSWORD=password"
      - "VERSION=1.0"
      - "MAIN_BRANCH=master"
      - "CI_BUILD_REF=$CI_BUILD_REF"
      - "CI_BUILD_REF_NAME=$CI_BUILD_REF_NAME"
      - "CI_PROJECT_ID=$CI_PROJECT_ID"

```

You can update everything with `docker-compose pull` followed by `docker-compose up -d`.
