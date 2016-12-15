#!/usr/bin/env bash

set -evu -o pipefail

#Install the maven-wrapper using the project's ideal Maven version to circumvent relying on the provided version.
if mvn -N io.takari:maven:wrapper --batch-mode -Dmaven=\$\{versions.maven.ideal\} -Denforcer.skip=true
then
        #Add mvnw to PATH
        PATH=${TRAVIS_BUILD_DIR}/:$PATH;

        echo "Able to install Maven Wrapper! Build will use the precongiured ideal version of Maven.";

        #Log info about Maven and Java version of Wrapper in order to force "on-demand" install to occur
        echo "Maven-Custom| Maven version is $(mvnw --version 2>&1 | awk '/Apache Maven/ {print $3}' | egrep -o '[^\"]*')"
        echo "Maven-Custom| Java version is $(mvnw --version 2>&1 | awk '/Java version/ {print $3}' | egrep -o '[^\,"]*')"

else
        echo "Unable to install Maven Wrapper! Build will continue by using the Travis-CI default Maven version.";

        #Log info about Maven and Java version of Travis-CI
        echo "Maven-Default| Maven version is $(mvn --version 2>&1 | awk '/Apache Maven/ {print $3}' | egrep -o '[^\"]*')"
        echo "Maven-Default| Java version is $(mvn --version 2>&1 | awk '/Java version/ {print $3}' | egrep -o '[^\,"]*')"
fi
