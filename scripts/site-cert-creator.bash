#!/bin/bash
ROOT_CERTS_DIR=${ROOT_CERTS_DIR:=/certs/root/ca}
INTERMEDIATE_DIR=$ROOT_CERTS_DIR/intermediate

source pre-checks.bash

trap ctrl_c INT

function cleanup() {
    rm -vf join ' ' "${created_files[@]}"
}

function ctrl_c() {
    echo "Stopping certificate creation due to ctrl-c"
    cleanup
    exit 1
}

function exit-check() {
    if ! [[ $? ]] ; then
        echo "bad call"
        exit
    fi
}

function join() {
    local IFS="$1"; shift; echo "$*"
}

if ! [[ $(find "$ROOT_CERTS_DIR/" -mindepth 1 -print 2>/dev/null) ]]
then
    echo -e "Expected certificate directory layout and openssl.cnf" \
         "files not found in $ROOT_CERTS_DIR.\nCorrect and try again."
    exit
fi

pre-checks-exit 'ls '"$INTERMEDIATE_DIR"'/ext'

created_files=()

for i in $INTERMEDIATE_DIR/ext/* ; do
    FILENAME="${i##*/}"
    CERT_NAME="${FILENAME%.*}"
    # Create key
    created_files+=($INTERMEDIATE_DIR"/private/$CERT_NAME.key")
    openssl genrsa -out "$INTERMEDIATE_DIR/private/$CERT_NAME.key" 2048
    exit-check
    chmod 400 "$INTERMEDIATE_DIR/private/$CERT_NAME.key"
    # Create CSR
    created_files+=($INTERMEDIATE_DIR"/csr/$CERT_NAME.csr")
    openssl req \
            -batch \
            -config "$INTERMEDIATE_DIR/openssl.cnf" \
            -key "$INTERMEDIATE_DIR/private/$CERT_NAME.key" \
            -new \
            -out "$INTERMEDIATE_DIR/csr/$CERT_NAME.csr" \
            -sha256
    exit-check
    chmod 400 "$INTERMEDIATE_DIR/csr/$CERT_NAME.csr"
    # Create certificate
    created_files+=($INTERMEDIATE_DIR"/certs/$CERT_NAME.cert")
    openssl x509 \
            -req \
            -days 375 \
            -sha256 \
            -in "$INTERMEDIATE_DIR/csr/$CERT_NAME.csr" \
            -out "$INTERMEDIATE_DIR/certs/$CERT_NAME.cert" \
            -extfile "$INTERMEDIATE_DIR/ext/$CERT_NAME.ext" \
            -CA "$INTERMEDIATE_DIR/certs/misoroboticsICA.cert" \
            -CAkey "$INTERMEDIATE_DIR/private/misoroboticsICA.key" \
            -CAcreateserial
    exit-check
    chmod 400 "$INTERMEDIATE_DIR/certs/$CERT_NAME.cert"
done

join ' ' "${created_files[@]}" > .files_created
