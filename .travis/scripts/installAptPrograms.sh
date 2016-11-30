#!/usr/bin/env bash

set -evu -o pipefail

if [[ "${OVERRIDE_JDK}" = 'true' ]] #If Installing Custom JDK
then
    if uname -a | grep x86_64 >/dev/null;
    then
        #64bit arch
        ARCH_SUFFIX=amd64
        JVM_LIBS_DIR=/usr/lib/jvm
    else
        #32bit arch
        ARCH_SUFFIX=i386
        JVM_LIBS_DIR=/usr/lib/jvm
    fi

    if [[ "${JDK_TYPE}" = 'open' ]] && [[ "${JDK}" = 'openjdk8' ]]
    then
        #JDK is openjdk8 custom with JavaFx 8
        sudo apt-get install openjdk-8 openjfx -y
        JVM_DIR=${JVM_LIBS_DIR}/java-1.8.0-openjdk-${ARCH_SUFFIX}/
    elif [[ "${JDK_TYPE}" = 'oracle' ]] && [[ "${JDK}" = 'oraclejdk8' ]]
    then
        #JDK is oraclejdk8 custom
        sudo apt-get install --no-install-recommends oracle-java8-installer -y
        JVM_DIR=${JVM_LIBS_DIR}/java-8-oracle/
    elif [[ "${JDK_TYPE}" = 'zulu' ]]
    then
        if [[ "${JDK}" = 'openjdk8' ]]
        then
            #JDK is openjdk8 custom from Zulu
            sudo apt-get install zulu-8 -y
            JVM_DIR=${JVM_LIBS_DIR}/zulu-8-${ARCH_SUFFIX}/
        elif [[ "${JDK}" = 'openjdk7' ]]
        then
            #JDK is openjdk7 custom from Zulu
            sudo apt-get install zulu-7 -y
            JVM_DIR=${JVM_LIBS_DIR}/zulu-7-${ARCH_SUFFIX}/
        fi
    else

        echo "Fail: \$OVERRIDE_JDK is true but a \$JDK_TYPE value of ${JDK_TYPE} is unsupported"
        exit 1;
    fi

    #List all installed Java alternatives for debug purposes
    sudo update-java-alternatives -l

    #Update the CI environment to use the custom JDK we just installed
    sudo update-java-alternatives -s ${JVM_DIR}
    sudo export JAVA_HOME=${JVM_DIR}

    #List all installed Java alternatives for debug purposes
    sudo update-java-alternatives -l
fi