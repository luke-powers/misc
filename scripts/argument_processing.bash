#!/bin/bash

ARGS=("$@")  # Easier than trying to reverse $BASH_ARGV
NAME=$(basename "$0")
USAGE="Usage: $NAME [OPTION..]
Argument processing template

Arguments:
 -h                show this text
 --test-set        example long option, takes value
 --test-flag       example long option
 tester            example argument
"

check-rest () {
    if [[ -n "$REST" ]] ; then
        echo "$NAME: Unknown argument $REST" >&2
        exit 1
    fi
}

process-args () {
    ARGS="$(getopt \
                -o h \
                -l help,test: \
                -n "$NAME" -- "$1")"
    if [[ $? =! 0 ]] ; then exit 1; fi
    eval set -- "$ARGS"
    while true; do
        case "$1" in
            -h | --help) echo "$USAGE"; exit 1 ;;
            --test-set) TEST_VAR="$2"; shift 2 ;;
            --test-flag) FLAG=true; shift 1 ;;
            --) TEST_ARG="$2"; shift ;;
            *) REST="$@"; check-rest ; break ;;
        esac
    done
}

process-args "$BASH_ARGV"
