#!/usr/bin/env bash

set -evu -o pipefail

if [[ "${TRAVIS_SECURE_ENV_VARS}" = 'true' ]]
then
    #If the build is secure we will sign the build artifacts
    mvnw clean install --batch-mode -Dmaven.profile=true -DskipTests=true -Dgpg.passphrase="${SIGNKEY_PASS}"
else
    #otherwise just do an unsigned build to verify there are no errors
    mvnw clean install --batch-mode -DskipTests=true -Dgpg.skip=true
fi
