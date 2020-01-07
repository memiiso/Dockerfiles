FROM centos:centos8
MAINTAINER memiiso <gel.yine.gel@gmail.com>

### setup applications
RUN dnf -y --quiet update
RUN dnf -y --quiet install wget zip git java-1.8.0-openjdk dnf-plugins-core

# clean
RUN rm -rf ~/.cache;\
    rm -rf /tmp/* ; \
    dnf -y clean all; \
    rm -rf /var/cache/yum

RUN java -version
