#!/usr/bin/env bash

set -evu -o pipefail

#Install the maven-wrapper using the project's ideal Maven version to circumvent relying on the provided version.
#Use "mvnw" instead of "mvn" for future Maven calls.
if mvn -N io.takari:maven:wrapper --batch-mode -Dmaven=\$\{versions.maven.ideal\} -Denforcer.skip=true
then
        #Create variables that point to the Maven Wrapper command. Use ${MVN:-mvn} to execute the wrapper or try to fallback
        export MVN="${TRAVIS_BUILD_DIR}/mvnw" && export MVN_NAME="Wrapper-Maven"
else
        #Make sure the variables are unset
        export MVN= && export MVN_NAME=
fi

#Log info about Maven and Java version of Wrapper in order to force "on-demand" install to occur
#If Wrapper install failed this also provides a way to determine that by looking over the log
echo "${MVN_NAME:-TravisCI-Maven}| Maven version is $(${MVN:-mvn} --version 2>&1 | awk '/Apache Maven/ {print $3}' | egrep -o '[^\"]*')"
echo "${MVN_NAME:-TravisCI-Maven}| Java version is $(${MVN:-mvn} --version 2>&1 | awk '/Java version/ {print $3}' | egrep -o '[^\,"]*')"
