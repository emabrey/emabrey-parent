#!/usr/bin/env bash

set -evu -o pipefail

if ! [[ "${INSTALL_JDK}" = 'true' ]]
then
    #Skipping custom JDK install
    echo "Skipped: \$\{INSTALL_JDK\} is not true, so APT repositories for the custom JDKs are not needed."
    exit 0;
fi

sudo apt-get purge openjdk* oracle-java* -qq -y
sudo apt-get autoclean -qq -y

if [[ "${JDK_TYPE}" = 'open' ]]
then
    sudo add-apt-repository ppa:openjdk-r/ppa -y
elif [[ "${JDK_TYPE}" = 'zulu' ]]
then
    #Private repository via http://repos.azulsystems.com/
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0x219BD9C9
    sudo apt-add-repository "deb http://repos.azulsystems.com/ubuntu stable main"
elif [[ "${JDK_TYPE}" = 'oracle' ]]
then
    sudo add-apt-repository ppa:webupd8team/java -y
fi

sudo apt-get update -qq -y