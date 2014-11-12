#!/bin/bash

# Still trying to figure out how to capture the last command
# PREV_CMD=$(fc -ln "$1" "$1" | sed '1s/^[[:space:]]*//')

# This always returns 0, can't find out how this works.
PREV_EXIT=$(echo $?)

API_KEY=$(cat ./api-key)

# Fallback: execute with ./pushbullet-exit.sh $? to pass error along
if [ -n "$1" ]; then
    PREV_EXIT=$1
fi

if [ "$PREV_EXIT" -eq "0" ]; then
    curl -u $API_KEY: -X POST https://api.pushbullet.com/v2/pushes --header 'Content-Type: application/json' --data-binary '{"type": "note", "title": "Command Successful", "body": "The command you had run on your computer has successfully completed."}' > /dev/null
else
    curl -u $API_KEY: -X POST https://api.pushbullet.com/v2/pushes --header 'Content-Type: application/json' --data-binary '{"type": "note", "title": "Command Error '$PREV_EXIT'", "body": "The command you had run on your computer did not exit successfully."}' > /dev/null
fi
exit 0
