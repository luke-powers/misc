#!/bin/bash

# Run as
# sh pomodoro.sh &
# OR
# TOO_EARLY=200 TOO_LATE=2000 sh pomodoro.sh&


if [ -z ${TOO_EARLY+x} ]; then
    TOO_EARLY=800
fi
if [ -z ${TOO_LATE+x} ]; then
    TOO_LATE=1900
fi

while [ `date +%k%M` -gt $TOO_EARLY -a `date +%k%M` -lt $TOO_LATE ] ; do
    zenity --text "Work" --info > /dev/null 2>&1 && sleep 1500
    zenity --text "Rest" --info > /dev/null 2>&1 && sleep 300
done
zenity --text "Outside of workday, done." --warning > /dev/null 2>&1
