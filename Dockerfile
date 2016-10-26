FROM openjdk:8-jdk

ARG MAVEN_VERSION=3.3.9
ARG USER_HOME_DIR="/root"
ARG DOCKER_MAVEN_GIT_REPO=https://raw.githubusercontent.com/carlossg/docker-maven/master/jdk-8

ENV MAVEN_HOME /usr/share/apache-maven-$MAVEN_VERSION
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

ADD http://apache.osuosl.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz /usr/share/
RUN ln -s $MAVEN_HOME/bin/mvn /usr/bin/mvn

ADD $DOCKER_MAVEN_GIT_REPO/mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
ADD $DOCKER_MAVEN_GIT_REPO/settings-docker.xml $MAVEN_HOME/ref/

ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]