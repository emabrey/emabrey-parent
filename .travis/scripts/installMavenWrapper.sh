#!/usr/bin/env bash

set -evu -o pipefail

#Install the maven-wrapper using the project's ideal Maven version to circumvent relying on the provided version.
#Use "mvnw" instead of "mvn" for future Maven calls.
mvn -N io.takari:maven:wrapper --batch-mode -Dmaven=\${versions.maven.ideal} -Denforcer.skip=true

#Log info about Maven and Java version of Wrapper in order to force "on-demand" install to occur
echo "Maven-Wrapper| Maven version is $(mvnw --version 2>&1 | awk '/Apache Maven/ {print $3}' | egrep -o '[^\"]*')"
echo "Maven-Wrapper| Java version is $(mvnw --version 2>&1 | awk '/Java version/ {print $3}' | egrep -o '[^\,"]*')"
