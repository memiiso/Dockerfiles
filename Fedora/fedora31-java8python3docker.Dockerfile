FROM fedora:31
MAINTAINER memiiso <gel.yine.gel@gmail.com>

ENV DOCKER_TLS_CERTDIR=/certs
RUN mkdir /certs /certs/client && chmod 1777 /certs /certs/client


RUN dnf -y --quiet update
RUN dnf -y --quiet install dnf-plugins-core wget zip git ca-certificates openssh-clients --nogpgcheck
RUN dnf -y --quiet install java-1.8.0-openjdk --nogpgcheck
RUN dnf -y --quiet install python38 python38-pip python38-wheel --nogpgcheck
RUN dnf -y --quiet install mysql postgresql --nogpgcheck

### setup python3
RUN python -V
RUN pip -V

RUN pip --quiet install --upgrade pip setuptools awscli boto3

# docker
RUN dnf -y config-manager --add-repo=https://download.docker.com/linux/fedora/docker-ce.repo --nogpgcheck
RUN dnf -y --quiet remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine
RUN dnf -y --quiet install docker-ce docker-ce-cli containerd.io --nobest --nogpgcheck
RUN systemctl enable docker \
    && systemctl is-enabled docker

RUN wget -q -O /usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" && \
    chmod +x /usr/local/bin/docker-compose

RUN wget -q -O /usr/local/bin/docker-entrypoint.sh https://raw.githubusercontent.com/docker-library/docker/master/docker-entrypoint.sh && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

# Clean
RUN rm -rf ~/.cache \
    && rm -rf /tmp/* \
    && dnf -y clean all

RUN docker --version
RUN dockerd --version

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/bin/bash" , "-l"]