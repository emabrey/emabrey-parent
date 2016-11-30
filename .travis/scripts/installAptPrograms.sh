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
        JVM_ID=java-1.8.0-openjdk-${ARCH_SUFFIX}
    elif [[ "${JDK_TYPE}" = 'oracle' ]] && [[ "${JDK}" = 'oraclejdk8' ]]
    then
        #JDK is oraclejdk8 custom
        echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
        echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
        sudo apt-get install --no-install-recommends oracle-java8-installer -y
        JVM_ID=java-8-oracle
    elif [[ "${JDK_TYPE}" = 'zulu' ]]
    then
        if [[ "${JDK}" = 'openjdk8' ]]
        then
            #JDK is openjdk8 custom from Zulu
            sudo apt-get install zulu-8 -y
            JVM_ID=zulu-8-${ARCH_SUFFIX}
        elif [[ "${JDK}" = 'openjdk7' ]]
        then
            #JDK is openjdk7 custom from Zulu
            sudo apt-get install zulu-7 -y
            JVM_ID=zulu-7-${ARCH_SUFFIX}
        fi
    else

        echo "Fail: \$OVERRIDE_JDK is true but a \$JDK_TYPE value of ${JDK_TYPE} is unsupported"
        exit 1;
    fi
    
    #Update the CI environment JAVA_HOME
    # Clunky workaround so that default Travis-CI JAVA_HOME (/usr/lib/jvm/java-7-oracle/) actually points to our custom
    # installed JDK. The correct way to do this would be to change the bash profile initialization, but that would be
    # even uglier to accomplish within a non-interactive environment. Without creating this symoblic link our changes to
    # JAVA_HOME would be undone as soon as the next shell is created for the next Travis-CI lifecycle phase
    export JAVA_HOME=${JVM_LIBS_DIR}/${JVM_ID}
    sudo ln -s ${JAVA_HOME} /usr/lib/jvm/java-7-oracle

    #Show current Java version for debug purposes
    sudo java -version
fi