#!/bin/bash

# Still trying to figure out how to capture the last command
# PREV_CMD=$(fc -ln "$1" "$1" | sed '1s/^[[:space:]]*//')

# This always returns 0, can't find out how this works.
PREV_EXIT=$(echo $?)

# Defaults for pushbullet API pushes
API_KEY=$(cat ./api-key)



# Fallback: execute with ./pushbullet-exit.sh $? to pass error along
if [ -n "$1" ]; then
    PREV_EXIT=$1
fi

if [ "$PREV_EXIT" -eq "0" ]; then
    TITLE="Command Successful."
    BODY="The command run on your computer has successfully completed."
else
    TITLE="Error "$PREV_EXIT" on command."
    BODY="The command run on your computer did not complete successfully."
fi

curl -u $API_KEY: -X POST https://api.pushbullet.com/v2/pushes --header 'Content-Type: application/json' --data-binary '{"type": "note", "title": "'"$TITLE"'", "body": "'"$BODY"'"}' > /dev/null
exit 0
