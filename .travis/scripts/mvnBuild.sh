#!/usr/bin/env bash

set -evu -o pipefail

if [[ "${TRAVIS_SECURE_ENV_VARS}" = 'true' ]]
then
    #If the build is secure we will sign the build artifacts
    mvn clean install -DskipTests=true -Dgpg.passphrase="${SIGNKEY_PASS}" -Dgpg.skip=false 
else
    #otherwise just do an unsigned build to verify there are no errors
    mvn clean install -DskipTests=true -Dgpg.skip=true
fi