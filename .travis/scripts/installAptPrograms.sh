#!/usr/bin/env bash

set -evu -o pipefail

#Setup needed variables based upon CPU ARCH
if uname -a | grep x86_64 >/dev/null;
then
    #64bit arch
    MIN_JDK_VER=6
    MAX_JDK_VER=9
    VALID_JDK_VER="^[${MIN_JDK_VER}-${MAX_JDK_VER}]+$"
    ARCH_SUFFIX=amd64
    JVM_LIBS_DIR=/usr/lib/jvm
else
    #32bit arch
    MIN_JDK_VER=6
    MAX_JDK_VER=9
    VALID_JDK_VER="^[${MIN_JDK_VER}-${MAX_JDK_VER}]+$"
    ARCH_SUFFIX=i386
    JVM_LIBS_DIR=/usr/lib/jvm
fi

if ! [[ "${INSTALL_JDK}" = 'true' ]]
then
    echo "Skipped: \$\{INSTALL_JDK\} is not true, so custom JDK install is being skipped."
    exit 0;
elif ! [[ ${JDK_VER} =~ ${VALID_JDK_VER} ]]
then
    echo "Fail: \$\{JDK_VER\} value of ${JDK_VER} is invalid. Required version: [${MIN_JDK_VER},${MAX_JDK_VERSION}]"
    exit 1;
fi

if [[ "${JDK_TYPE}" = 'open' ]]
then
    JDK_PACKAGE=openjdk-${JDK_VER}
    JVM_ID=java-1.${JDK_VER}.0-openjdk-${ARCH_SUFFIX}
    sudo apt-get install "${JDK_PACKAGE}" -y
elif [[ "${JDK_TYPE}" = 'oracle' ]]
then
    JDK_PACKAGE=oracle-java${JDK_VER}-installer
    JVM_ID=java-${JDK_VER}-oracle
    echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections
    echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections
    sudo apt-get install --no-install-recommends "${JDK_PACKAGE}" -y
elif [[ "${JDK_TYPE}" = 'zulu' ]]
then
    JDK_PACKAGE=zulu-${JDK_VER}
    JVM_ID=zulu-${JDK_VER}-${ARCH_SUFFIX}
    sudo apt-get install "${JDK_PACKAGE}" -y
else
    echo "Fail: \$\{JDK_TYPE\} value of ${JDK_TYPE} is unsupported. Supported types: open, oracle, zulu"
    exit 1;
fi

#Update the CI environment JAVA_HOME
# Clunky workaround so that default Travis-CI JAVA_HOME ("/usr/lib/jvm/java-7-oracle/") actually points to our custom
# installed JDK. The correct way to do this would be to change the bash profile initialization, but that would be
# even uglier to accomplish within a non-interactive environment. Without creating this symbolic link our changes to
# JAVA_HOME would be undone as soon as the next shell is created for the next Travis-CI lifecycle phase. To make sure
# this clunky fix is durable, we fetch the original JAVA_HOME directory before overwriting it, so that if the default
# directory is changed our hack doesn't need manual adjustment like it would if it was hard-coded.
ORIGINAL_JAVA_HOME=${JAVA_HOME}
export JAVA_HOME=${JVM_LIBS_DIR}/${JVM_ID}
sudo ln -s "${JAVA_HOME}" "${ORIGINAL_JAVA_HOME}"

#Show current Java versions for debug purposes
echo "PATH| Java version is $(java -version 2>&1 | awk '/java version/ {print $3}' | egrep -o '[^\"]*')"
echo "PATH| Javac version is $(javac -version 2>&1 | awk '/javac/ {print $2}' | egrep -o '[^\"]*')"
echo "TravisCI-Maven| Java version is $(mvn --version 2>&1 | awk '/Java version/ {print $3}' | egrep -o '[^\,"]*')"
