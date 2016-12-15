#!/usr/bin/env bash

set -evu -o pipefail

#Use Maven Wrapper if available
if mvnw --version
then
    MVN=mvnw
fi

#Run Maven unit tests
${MVN:-mvn} clean test --batch-mode -DskipTests=false -Dgpg.skip=true
