#!/bin/bash

ROOT_CERTS_DIR=${ROOT_CERTS_DIR:=/certs/root/ca}
INTERMEDIATE_DIR=$ROOT_CERTS_DIR/intermediate

INTERMEDIATE_CA=${INTERMEDIATE_CA:=intermediate.ica.cert}
INTERMEDIATE_CA_KEY=${INTERMEDIATE_CA_KEY:=intermediate.ica.key}
EXISTING_CERTS=.existing_certs
NAME=$(basename "$0")
SHOW=false
CLEAN=false
PASSED_PATH=

USAGE="Usage: $NAME [--clean|--iname|--show] [root-path]
A Certificate Generator
Arguments:
 -h                show this text
 --clean           Remove all certs and keys (leaves ext files)
 --show            Show created certs
 root-path         Path to root ca ($ROOT_CERTS_DIR)
"

source pre-checks.bash

trap ctrl-c INT

check-rest () {
    if [[ -n "$REST" ]] ; then
        echo "$NAME: Unknown argument '$REST'" >&2
        exit 1
    fi
}

cleanup() {
    rm -vf "${created_files[@]}"
}

create-certs () {
    CERT_NAME=$1
    created_files+=($INTERMEDIATE_DIR"/certs/$CERT_NAME.cert")
    openssl x509 \
            -req \
            -days 375 \
            -sha256 \
            -in "$INTERMEDIATE_DIR/csr/$CERT_NAME.csr" \
            -out "$INTERMEDIATE_DIR/certs/$CERT_NAME.cert" \
            -extfile "$INTERMEDIATE_DIR/ext/$CERT_NAME.ext" \
            -CA "$INTERMEDIATE_DIR/certs/$INTERMEDIATE_CA" \
            -CAkey "$INTERMEDIATE_DIR/private/$INTERMEDIATE_CA_KEY" \
            -CAcreateserial
    exit-check
    chmod 600 "$INTERMEDIATE_DIR/certs/$CERT_NAME.cert"
}

create-csr () {
    CERT_NAME=$1
    created_files+=($INTERMEDIATE_DIR"/csr/$CERT_NAME.csr")
    openssl req \
            -batch \
            -config "$INTERMEDIATE_DIR/openssl.cnf" \
            -key "$INTERMEDIATE_DIR/private/$CERT_NAME.key" \
            -new \
            -out "$INTERMEDIATE_DIR/csr/$CERT_NAME.csr" \
            -sha256
    exit-check
    chmod 600 "$INTERMEDIATE_DIR/csr/$CERT_NAME.csr"
}

create-keys () {
    CERT_NAME=$1
    created_files+=($INTERMEDIATE_DIR"/private/$CERT_NAME.key")
    openssl genrsa -out "$INTERMEDIATE_DIR/private/$CERT_NAME.key" 2048
    exit-check
    chmod 600 "$INTERMEDIATE_DIR/private/$CERT_NAME.key"
}

ctrl-c() {
    echo "Stopping certificate creation due to ctrl-c"
    cleanup
    exit 1
}

exit-check() {
    if [[ $? != 0 ]] ; then
        echo "Call returned with non-zero."
        cleanup
        exit
    fi
}

get-existing-certs() {
    # Loads existing certs into the $created_files variable.
    ret=0
    if [[ -s "$ROOT_CERTS_DIR/$EXISTING_CERTS" ]] ; then
         readarray -t created_files < "$ROOT_CERTS_DIR/$EXISTING_CERTS"
    else
        echo "No certs created for $ROOT_CERTS_DIR/$EXISTING_CERTS"
        ret=1
    fi

    return $ret
}

join() {
    local IFS="$1"; shift; echo "$*"
}

main() {
    process-args "$@"

    if ! [[ $(find "$ROOT_CERTS_DIR/" -mindepth 1 -print 2>/dev/null) ]]
    then
        echo -e "Expected certificate directory layout not found in " \
             "$ROOT_CERTS_DIR.\nCorrect and try again."
        exit
    fi

    pre-checks-exit 'ls '"$INTERMEDIATE_DIR"'/ext'

    created_files=()

    for i in $INTERMEDIATE_DIR/ext/* ; do
        FILENAME="${i##*/}"
        CERT_NAME="${FILENAME%.*}"
        if [[ -s "$INTERMEDIATE_DIR/certs/$CERT_NAME.cert" ]] ; then
            echo "Cert '$CERT_NAME.cert' already exists."
        else
            echo -e "Creating '$CERT_NAME.cert'.\n"
            # Create key
            create-keys "$CERT_NAME"
            # Create CSR
            create-csr "$CERT_NAME"
            # Create certificate
            create-certs "$CERT_NAME"
        fi
    done
    update-certs-file-list "${created_files[@]}"
}

process-args () {
    ARGS="$(getopt \
                -o h \
                -l clean,help,show \
                -n "$NAME" -- "$@")"
    if [[ $? != 0 ]] ; then exit 1; fi
    eval set -- "$ARGS"
    while true; do
        case "$1" in
            -h | --help) echo "$USAGE"; exit 1 ;;
            --clean) CLEAN=true; shift ;;
            --show) SHOW=true; shift ;;
            --) if [[ "z$2" != "z" ]] ; then
                    PASSED_PATH="$2"; shift 2
                else
                    shift 1
                fi;;
            *) REST="$*"; check-rest ; break ;;
        esac
    done

    if [[ "z$PASSED_PATH" != "z" ]] ; then
        echo "old path $ROOT_CERTS_DIR"
        ROOT_CERTS_DIR=$PASSED_PATH
        INTERMEDIATE_DIR=$ROOT_CERTS_DIR/intermediate
        echo "new path $ROOT_CERTS_DIR"
    fi
    if [[ $SHOW = true ]] ; then
        if [[ -s "$ROOT_CERTS_DIR/$EXISTING_CERTS" ]] ; then
            tr ' ' '\n' < "$ROOT_CERTS_DIR/$EXISTING_CERTS"
        fi
        exit
    fi
    if [[ $CLEAN = true ]] ; then
        if ! get-existing-certs ; then
            echo "No files to remove in $ROOT_CERTS_DIR."
            exit
        fi
        printf "Really remove all certs? (y/n)"
        read CONFIRM
        if [[ "$CONFIRM" = "y" ]] ; then
            cleanup
            rm -vf "$ROOT_CERTS_DIR/$EXISTING_CERTS"
            exit
        else
            echo "Not removing certs."
            exit
        fi
    fi
}

update-certs-file-list () {
    all_certs_list="$*"
    if [[ -s "$ROOT_CERTS_DIR/$EXISTING_CERTS" ]] ; then
        NEW_CERTS=("${all_certs_list[@]}")
        get-existing-certs
        all_certs_list=("${NEW_CERTS[@]}" "${created_files[@]}")
    fi
    join $'\n' "${all_certs_list[@]}" > "$ROOT_CERTS_DIR/$EXISTING_CERTS"
}

main "$@"
