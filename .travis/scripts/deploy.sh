#!/usr/bin/env bash

set -evu -o pipefail

if [[ "${CI}" != "true" ]] || [[ "${TRAVIS}" != "true" ]]
then

    #Script called without meeting the required prerequisites for deployment
    echo "Fail: deploy required to be during a Travis-CI build job"
    exit 1;

elif [[ "${TRAVIS_REPO_SLUG}" != "emabrey/emabrey-parent" ]] || [[ "${TRAVIS_SECURE_ENV_VARS}" != "true" ]]
then

    #Script called without meeting the required prerequisites for deployment
    echo "Fail: deploy required to be a secure build of the ${TRAVIS_REPO_SLUG} repository"
    exit 1;

elif [[ "${DEPLOY}" != "true" ]]
then

    #Script called without meeting the required prerequisites for deployment
    echo "Fail: deploy requires build job specific approval via the \$DEPLOY variable"
    exit 1;

fi
#If we have reached this line the build is an allowed Travis-CI build job securely building the correct git repo


#We clean the current contents, rebuilding the artifacts, signing them, installing them and then deploying them
mvn clean deploy -DskipTests=true -Dgpg.passphrase="${SIGNKEY_PASS}" -Dgpg.skip=false