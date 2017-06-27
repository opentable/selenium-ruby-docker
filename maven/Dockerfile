FROM docker.otenv.com/ot-java8:latest

RUN mkdir /opt/maven && \
  curl -sSf http://apache.osuosl.org/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz | \
  tar -xzvC /opt/maven --strip-components=1

ADD ot-build-settings/maven/settings.xml /opt/maven/conf/settings.xml

ENV PATH $PATH:/opt/maven/bin
