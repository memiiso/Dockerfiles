FROM docker:git
MAINTAINER memiiso <gel.yine.gel@gmail.com>

WORKDIR /root
RUN apk --quiet --no-cache update
RUN apk --quiet --no-cache add -X http://dl-cdn.alpinelinux.org/alpine/v3.10/main build-base cmake postgresql-dev gcc musl-dev curl bash openssl gettext wget 'python3-dev<3.8'
RUN apk --quiet --no-cache add -X http://dl-cdn.alpinelinux.org/alpine/v3.10/main postgresql mysql mysql-client
RUN apk --quiet --no-cache add -X http://dl-cdn.alpinelinux.org/alpine/v3.10/main 'python3<3.8' zip openjdk8-jre

RUN rm -f /usr/bin/python && ln -s /usr/bin/python3 /usr/bin/python
RUN rm -f /usr/bin/pip && ln -s /usr/bin/pip3 /usr/bin/pip

RUN pip --quiet install --upgrade pip setuptools wheel awscli
RUN pip --quiet install --upgrade urllib3==1.24.3 pyyaml==5.2 boto3 docker pylint coverage s3transfer testcontainers py4j
RUN pip --quiet install --upgrade numpy>=1.16.4 pandas>=0.24.2 psycopg2-binary pymysql mysql-connector
RUN pip --quiet install --upgrade pyspark>=2.4.4 SQLAlchemy pymysql psycopg2

RUN rm -rf /var/cache/apk/*
RUN rm -rf ~/.cache
RUN rm -rf /tmp/*
RUN python --version
RUN pip --version
RUN java -version