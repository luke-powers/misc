#!/bin/bash

# Run as
# sh pomodoro.sh &
# OR
# TOO_EARLY=200 TOO_LATE=2000 WORK_DURATION=10 REST_DURATION=2 sh pomodoro.sh&

REST_DURATION=${REST_DURATION:-5}
TOO_EARLY=${TOO_EARLY:-800}
TOO_LATE=${TOO_LATE:-1900}
WORK_DURATION=${WORK_DURATION:-20}

while [ `date +%k%M` -gt $TOO_EARLY -a `date +%k%M` -lt $TOO_LATE ] ; do
    next_work=$((`date +%k%M` + $WORK_DURATION))
    if [[ $(($next_work%100/60)) > 0 ]] ; then
        next_work=$(($next_work+40))
    fi
    zenity --text "$(date +%k%M) - Work until $next_work" --info --width 100 > /dev/null 2>&1
    sleep $(($WORK_DURATION*60))
    next_rest=$((`date +%k%M` + $REST_DURATION))
    if [[ $(($next_rest%100/60)) > 0 ]] ; then
        next_rest=$((next_rest+40))
    fi
    zenity --text "$(date +%k%M) - Rest until $next_rest" --info --width 100 > /dev/null 2>&1
    sleep $(($REST_DURATION*60))
done
zenity --text "Outside of workday, done." --warning > /dev/null 2>&1
