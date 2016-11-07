FROM python:3.5.2

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
RUN apt-get update && apt-get install --fix-missing -y \
    libsasl2-modules \
    locales

RUN echo "America/Sao_Paulo" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata
RUN echo 'pt_BR.UTF-8 UTF-8' >> /etc/locale.gen && locale-gen && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install Spark/Mesos

RUN apt-get install -y default-jre python-setuptools python-protobuf wget libcurl3
RUN wget http://repos.mesosphere.com/debian/pool/main/m/mesos/mesos_0.28.2-2.0.27.debian81_amd64.deb -c -O /tmp/mesos.deb

RUN dpkg -i /tmp/mesos.deb

ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so

RUN mkdir -p /opt/spark
RUN curl -s http://d3kbcqa49mib13.cloudfront.net/spark-2.0.1-bin-hadoop2.6.tgz | tar -xz -C .
RUN mv spark-2.0.1-bin-hadoop2.6 /opt/spark/dist

ENV SPARK_HOME /opt/spark/dist

