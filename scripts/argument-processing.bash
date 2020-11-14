#!/bin/bash
# https://stackoverflow.com/a/29754866

NAME=$(basename "$0")
USAGE="Usage: $NAME [OPTION..]
Argument processing template

Arguments:
 -h                   show this text
 -f | --flag          flag, takes no value
 -g | --next-flag     another flag, takes no value
 -i | --another-flag  another flag, takes no value
 -s | --set           set, takes value
 -t | --next-set      another set, takes value
 tester               argument

Example test runs:
 argument_processing -f -g -i -s 42 bob
 argument_processing -fgi -s 42 bob -t 43
 argument_processing -t 43 --flag --next-flag --another-flag bob --set 42
 argument_processing bob --set 42 -fgi -t 43
 argument_processing bob ---flag --set 42 --next-flag --another-flag -t 43
"

FLAG=false
NEXT_FLAG=false
ANOTHER_FLAG=false
TEST_VAR=-1
ANOTHER_TEST_VAR=-1
TEST_ARG='empty'

check-rest () {
    if [[ -n "$REST" ]] ; then
        echo "$NAME: Unknown argument '$REST'" >&2
        exit 1
    fi
}

process-args () {
    ARGS="$(getopt \
                -o fghis:t: \
                -l flag,next-flag,another-flag,help,set:,next-set: \
                -n "$NAME" -- "$@")"
    if [[ $? != 0 ]] ; then exit 1; fi
    eval set -- "$ARGS"
    while true; do
        case "$1" in
            -f | --flag) FLAG=true; shift 1 ;;
            -g | --next-flag) NEXT_FLAG=true; shift 1 ;;
            -h | --help) echo "$USAGE"; exit 1 ;;
            -i | --another-flag) ANOTHER_FLAG=true; shift 1 ;;
            -s | --set) TEST_VAR="$2"; shift 2 ;;
            -t | --next-set) ANOTHER_TEST_VAR="$2"; shift 2 ;;
            --) if [[ "z$2" != "z" ]] ; then
                    TEST_ARG="$2"; shift 2
                else
                    shift 1
                fi ;;
            *) REST="$*"; check-rest ; break ;;
        esac
    done
    echo -e "flag: $FLAG, next-flag: $NEXT_FLAG, another-flag: $ANOTHER_FLAG, set: $TEST_VAR, next-set: $ANOTHER_TEST_VAR, argument $TEST_ARG" 
}

process-args "$@"
