#!/usr/bin/env bash

set -evu -o pipefail

#If a custom JDK is used this installs the correct repository for the specific JDK

if [[ "${OVERRIDE_JDK}" = 'true' ]]
then
    sudo apt-get purge openjdk* zulu* oracle-java* -q -y
    sudo apt-get autoclean -q -y
    sudo apt-get autoremove -q -y

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

    sudo apt-get update -q -y
fi