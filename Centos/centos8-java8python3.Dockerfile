FROM centos:centos8
MAINTAINER memiiso <gel.yine.gel@gmail.com>
### setup applications
RUN dnf -y --quiet update
RUN dnf -y --quiet install wget zip git java-1.8.0-openjdk dnf-plugins-core
RUN dnf -y --quiet install python38 python38-pip python38-wheel libpq-devel postgresql gcc python38-devel --nogpgcheck

### setup default python
RUN alternatives --set python /usr/bin/python3
RUN alternatives --install /usr/bin/pip pip /usr/bin/pip3 60

RUN pip --quiet install --upgrade pip setuptools awscli boto3

# clean
RUN rm -rf ~/.cache;\
    rm -rf /tmp/* ; \
    dnf -y clean all; \
    rm -rf /var/cache/yum

RUN python --version \
    && pip --version
