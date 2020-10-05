FROM centos:centos8
MAINTAINER memiiso <gel.yine.gel@gmail.com>

ENV AZKABAN_VERSION=master

### setup applications
RUN dnf -y --quiet update
RUN dnf -y --quiet install wget zip git java-1.8.0-openjdk dnf-plugins-core
ENV JAVA_HOME=/etc/alternatives/jre
RUN java -version

WORKDIR /app
RUN git clone https://github.com/azkaban/azkaban.git
WORKDIR /app/azkaban
RUN git checkout ${AZKABAN_VERSION}
RUN ./gradlew build installDist -x test
# clean
RUN rm -rf ~/.cache;\
    rm -rf ~/.m2;\
    rm -rf /tmp/* ; \
    dnf -y clean all; \
    rm -rf /var/cache/yum

WORKDIR /app/azkaban/azkaban-solo-server/build/install/azkaban-solo-server
RUN echo $'\nmemCheck.enabled=false' >> plugins/jobtypes/commonprivate.properties
RUN echo $'\nazkaban.memory.check=false' >> plugins/jobtypes/commonprivate.properties

RUN chmod +x bin/*.sh

RUN echo $'#!/usr/bin/env bash' > run.sh && \
    echo $'' >> run.sh && \
    echo $'bash ./bin/start-solo.sh' >> run.sh && \
    echo $'sleep 5' >> run.sh && \
    echo $'tail --pid=$(<\'currentpid\') -f /dev/null' >> run.sh
RUN chmod +x run.sh

ENTRYPOINT [ "bash", "run.sh" ]
