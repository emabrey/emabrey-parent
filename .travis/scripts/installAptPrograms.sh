#!/usr/bin/env bash

set -evu -o pipefail

if [[ "${OVERRIDE_JDK}" = 'true' ]] #If Installing Custom JDK
then
    if [[ "${JDK_TYPE}" = 'open' ]] && [[ "${JDK}" = 'openjdk8' ]]
    then
        #JDK is openjdk8 custom with JavaFx 8
        sudo apt-get install openjdk-8 openjfx -y
    elif [[ "${JDK_TYPE}" = 'oracle' ]] && [[ "${JDK}" = 'oraclejdk8' ]]
    then
        #JDK is oraclejdk8 custom
        sudo apt-get install --no-install-recommends oracle-java8-installer -y
    elif [[ "${JDK_TYPE}" = 'zulu' ]]
    then
        if [[ "${JDK}" = 'openjdk8' ]]
        then
            #JDK is openjdk8 custom from Zulu
            sudo apt-get install zulu-8 -y
        elif [[ "${JDK}" = 'openjdk7' ]]
        then
            #JDK is openjdk7 custom from Zulu
            sudo apt-get install zulu-7 -y
        fi
    fi

    #Switch to custom JDK
    jdkswitcher use "${JDK}"
fi

#Install the shell checker tool to run as part of the unit tests since Maven can't verify shell scripts
sudo apt-get install shellcheck -y