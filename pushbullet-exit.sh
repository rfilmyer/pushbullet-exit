#!/bin/bash

PREV_EXIT=$(echo $?)
PREV_CMD=$(!:p)

echo "Exit Code" $PREV_EXIT", Previous Command: " $PREV_CMD
#echo $prev_exit
