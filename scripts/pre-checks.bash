#!/bin/bash

function pre-check() {
    output=$($1 2>&1)
    exitCode=$?
    retCode=0
    if [[ $exitCode -eq 127 ]] ; then
        echo "Missing $1, install it before running. $exitCode"
        retCode=1
    elif [[ $exitCode -ne 0 ]] ; then
        if [[ $1 == *"ssh"* ]] ; then
            output=$(echo $output | tr -d "\r")
            if [[ $exitCode -ne 1 ]]; then
                echo -e "Error ssh'ing:\n\t$output $exitCode"
                retCode=1
            fi
        else
            echo -e "Error running $1:\n\t$output. $exitCode"
            retCode=1
        fi
    fi
    return $retCode
}

function pre-checks() {
    retCode=0
    for check in "$@" ; do
        pre-check "$check"
        retCode=$(( $? + $retCode ))
    done
    if [[ $retCode -gt 0 ]] ; then
        echo "Pre-checks failed."
        retCode=1
    else
        retCode=0
    fi
    return $retCode
}

function pre-checks-exit() {
    pre-checks "$@"
    if [[ $? -eq 1 ]] ; then
        exit
    fi
}

