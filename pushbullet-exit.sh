#!/bin/bash
# pushbullet-exit.sh by Roger Filmyer.
# MIT license.

# Things to add:
# proper getopts handling
# less hacky way to handle account tokens
# stdin > message body
# help message

# Still can't figure out how to capture the last command and exit status
# PREV_CMD=$(fc -ln "$1" "$1" | sed '1s/^[[:space:]]*//')
# PREV_EXIT=$(echo $?)

# new ACCT_TOKEN handling - look for key in this priority:
# 1. -k flag in command
# 2. PUSHBULLET_ACCT_TOKEN environment variable
# 3. Config file  of the other pushbullet shell script
# 4. Working directory: ./api-key (Will be deprecated)

if [ "$1" == "--help" ]; then
echo "Usage: pushbullet-exit.sh [OPTION]"
exit 0
fi

CAUGHT_EXIT=FALSE
MSG_GIVEN=TRUE #Indicates whether the user has supplied a custom message

if [ -r ./acct-token ]; then
ACCT_TOKEN=$(cat ./acct-token)
fi

while getopts ":pm:t:" opt; do
    case $opt in
        p)
            PASSTHRU=TRUE
            ;;
        m)
            CUSTOM_MESSAGE=($OPTARG)
            MSG_GIVEN=TRUE
            shift
            ;;
        t)
            ACCT_TOKEN=($OPTARG)
            shift
            ;;
#        [0-255])
#            PREV_EXIT=$1
#            CAUGHT_EXIT=TRUE
#            echo "Caught PREV_EXIT in getopts:" $PREV_EXIT
#            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
    shift
#    echo "current args: $@"
    OPTIND=1
done

# Fallback: execute with ./pushbullet-exit.sh $? to pass error along
if [ -n "$1" ]; then
    if [ "$1" -lt 255 -a "$1" -ge 0 ]; then
        PREV_EXIT=$1
        CAUGHT_EXIT=TRUE
#        echo "Caught PREV_EXIT in fallback:" $PREV_EXIT
    fi
fi

if [ "$CAUGHT_EXIT" = FALSE ]; then
    TITLE="Command Complete."
    BODY="The command has exited."
elif [ "$PREV_EXIT" -eq "0" ]; then
    TITLE="Command Successful."
    BODY="The command run on your computer has successfully completed."
elif [ "$PREV_EXIT" -lt "255" -a "$PREV_EXIT" -ge "1" ]; then
    TITLE="Error "$PREV_EXIT" on command."
    BODY="The command run on your computer did not complete successfully."
else
    echo "Invalid exit status: $?" >&2
    exit 3
fi

if [ "$MSG_GIVEN" = "TRUE" ]; then
    BODY=$CUSTOM_MESSAGE
fi

if [ -z "$ACCT_TOKEN" ]; then
   echo "Could not find account token" >&2
   exit 2
fi

# Is there a less hacky way to work with JSON in a shell script?
# Works with v2 of the Pushbullet API.
curl -s -S -u $ACCT_TOKEN: -X POST https://api.pushbullet.com/v2/pushes --header 'Content-Type: application/json' --data-binary '{"type": "note", "title": "'"$TITLE"'", "body": "'"$BODY"'"}' > /dev/null

if [ "$PASSTHRU" = TRUE ]; then
    exit $PREV_EXIT
fi
exit 0
