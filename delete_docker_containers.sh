#!/bin/bash

# Deletes exited Docker containers based on the specified command.
# (status detection is pretty hacky, docker output whitespace management to be
# improved)

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <COMMAND>"
fi

is_header=1
docker ps --all | sed -e 's/\(\s\)\+/ /g' \
    | while IFS=" " read -r CONTAINER_ID IMAGE COMMAND CREATED_NB CREATED_GRAN CREATED_AGO STATUS BLAH
do
    if [ $is_header -eq 1 ]; then
        is_header=0
        continue # header row
    fi

    if [[ "$STATUS" != "Exited" ]]; then
        echo "Image $CONTAINER_ID has status: '$STATUS', skipping..."
        continue
    fi

    if [[ $COMMAND == *"$1"* ]]
    then
        echo "Deleting $CONTAINER_ID..."
        result="$(docker rm $CONTAINER_ID 2>&1 > /dev/null)"
        echo "$result"
    fi
done
