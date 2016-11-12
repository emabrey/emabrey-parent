#!/usr/bin/env bash

set -evu -o pipefail

if [[ "${TRAVIS_SECURE_ENV_VARS}" = 'true' ]] && [[ -r "${SIGNKEY_ENCRYPTED_FILE}" ]]
then
    #Decrypt the GPG sign key if we are on a secure build environment and the encrypted key exists
    openssl aes-256-cbc -k "${SIGNKEY_KEK_PASS}" -in "${SIGNKEY_ENCRYPTED_FILE}" -out "${SIGNKEY_DECRYPTED_FILE}" -d
    gpg --batch --fast-import "${SIGNKEY_DECRYPTED_FILE}"
fi
