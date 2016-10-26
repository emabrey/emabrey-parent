FROM openjdk:8-jdk

MAINTAINER Emily Mabrey <emilymabrey93@gmail.com>

#####
# The ARG variables are configurable at image runtime, so for instance you can specify a different MVN_VERSION.
# However, the ENV variables are constant and cannot be changed at runtime, though they are available during
# runtime from within the container environment. Because of these differing features, the variables of this Dockerfile
# are all both defined as ARG and ENV. ENV variables always overrides ARG variables of the same name, so by providing
# default ENV variable values which activate if the ARG value is empty, and providing empty ARG values by default, we
# get the best of both worlds- constant variables using sane defaults which can be customized just as if they were
# normal build arguments.
#####
ARG MVN_VERSION
ARG USER_HOME_DIR
ARG MVN_DLOAD_FILE
ARG MVN_DLOAD_URL
ARG MAVEN_HOME
ARG MAVEN_CONFIG
ARG DOCKER_MVN_REPO
ARG ENTRYPOINT_SCRIPT

ENV MVN_VERSION=${MVN_VERSION:-3.3.9} \
	USER_HOME_DIR=${USER_HOME_DIR:-"/root"} \
	MVN_DLOAD_FILE=${MVN_DLOAD_FILE:-apache-maven-$MVN_VERSION-bin.tar.gz} \
	MVN_DLOAD_URL=${MVN_DLOAD_URL:-http://apache.osuosl.org/maven/maven-3/$MVN_VERSION/binaries/$MVN_DLOAD_FILE} \
	MAVEN_HOME=${MAVEN_HOME:-/usr/share/maven} \
	MAVEN_CONFIG=${MAVEN_CONFIG:-"$USER_HOME_DIR/.m2"} \
	DOCKER_MVN_REPO=${DOCKER_MVN_REPO:-https://raw.githubusercontent.com/carlossg/docker-maven/master/jdk-8} \
	ENTRYPOINT_SCRIPT=${ENTRYPOINT_SCRIPT:-/usr/local/bin/mvn-entrypoint.sh}

#####
# This RUN command downloads and extracts the Maven binaries for Maven version MVN_VERSION, chmods the mvn file to be
# executable for all users and then symbolically links to that mvn executable from the /usr/local/bin directory. The
# full installation contents are of course ultimately downloaded into the MAVEN_HOME directory. We must manually
# mkdir the output directory at MAVEN_HOME because tar does not support output paths that do not already exist.
#####
RUN	mkdir -p $MAVEN_HOME \
	&& curl -fsSL $MVN_DLOAD_URL | tar -xzC $MAVEN_HOME --strip-components=1 \
	&& chmod a+x $MAVEN_HOME/bin/mvn \
	&& ln -s $MAVEN_HOME/bin/mvn /usr/bin/mvn

#####
# This RUN command downloads and extracts the needed files from the Docker Maven Github repository into their respective
# image directories. If any of the directories on the output paths don't already exist this command will create them on
# the fly, so there is no need to mkdir beforehand. After the download is complete the "mvn-entrypoint.sh" bash script
# is marked as executable for all users via a chmod command.
#####
RUN curl -fsSL $DOCKER_MVN_REPO/settings-docker.xml --output $MAVEN_HOME/ref/settings-docker.xml --create-dirs \
	&& curl -fsSL $DOCKER_MVN_REPO/mvn-entrypoint.sh --output $ENTRYPOINT_SCRIPT --create-dirs  \
	&& chmod a+x $ENTRYPOINT_SCRIPT

#####
# This configures the ENTRYPOINT of this Docker image to be the mvn-entrypoint script we previously downloaded. The
# script configures the configuration files of the Maven environment to match the configuration files available via the
# mounted "/root/.m2" volume, if such files exist. To propagate host machine Maven configuration into the Docker image
# simply bind the host .m2 directory to the image's /root/.m2 directory during the "docker run". The entrypoint script
# will automatically handle the rest of the steps for configuring the build machine settings to match the ones provided.
#####
VOLUME $MAVEN_CONFIG
ENTRYPOINT ["$ENTRYPOINT_SCRIPT"]