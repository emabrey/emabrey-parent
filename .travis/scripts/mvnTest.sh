#!/usr/bin/env bash

set -evu -o pipefail

#Run Maven unit tests
mvn clean test -Dgpg.skip=true