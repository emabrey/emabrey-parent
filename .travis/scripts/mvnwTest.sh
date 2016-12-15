#!/usr/bin/env bash

set -evu -o pipefail

#Run Maven unit tests
mvnw clean test --batch-mode -DskipTests=false -Dgpg.skip=true
