#!/usr/bin/env bash

set -evu -o pipefail

#Use Maven Wrapper if available
if ${MVNW_CMD} --version
then
    MVN=${MVNW_CMD}
fi

#Run Maven unit tests
${MVN:-mvn} clean test --batch-mode -DskipTests=false -Dgpg.skip=true
