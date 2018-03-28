#!/bin/bash

if [ -z ${TOO_EARLY+x} ]; then
    TOO_EARLY=800
fi
if [ -z ${TOO_LATE+x} ]; then
    TOO_LATE=1900
fi

while [ `date +%k%M` -gt $TOO_EARLY -a `date +%k%M` -lt $TOO_LATE ] ; do
    zenity --text "Take a rest" --info > /dev/null 2>&1 && sleep 300
    zenity --text "Back to work" --info > /dev/null 2>&1 && sleep 1500
done
zenity --text "Outside of workday, done." --warning > /dev/null 2>&1
