#! /usr/bin/env bash

set -xe

SECRETS_FILE_PATH=${SECRETS_FILE_PATH:-.secrets_password_file}

[[ -f $SECRETS_FILE_PATH ]] || pass SysAdmin/Infrastructure-Secrets-Key | tee $SECRETS_FILE_PATH

function enc_dec() {
    openssl aes-256-cbc -iter 100000 -pbkdf2 -pass file:$SECRETS_FILE_PATH $@
}

if [[ "$1" == "update" ]]; then
    tar cv secrets | enc_dec > secrets.tar.enc
elif [[ "$1" == "extract" ]]; then
    enc_dec -d -in secrets.tar.enc | tar xv
else
    echo "Invalid parameters. Must specify 'update' or 'extract'."
    exit 1
fi
