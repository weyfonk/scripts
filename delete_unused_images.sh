#!/usr/bin/env bash

print_usage() {
    echo "Usage: $0 [IMAGE_NAME]"
    echo "Delete all images up to the one which repo name is specified,"
    echo "and delete all stopped containers that depend on those images."
    echo "$0 -h # prints this message"
}

if [ $(which docker) = "" ]
then
    "Docker was not found on this machine. You might not need this script!"
fi

if [ $# -eq 0 ]
then
    echo "You have not specified any repo to stop at. Delete *all* images?"
    echo "Type 'yes' to confirm your choice, or anything else to cancel."
    read -r answer
    if [[ ! $answer = 'yes' ]]
    then
        echo "Exiting..."
        exit 1
    fi
elif [[ $1 = "-h" ]]
then
    print_usage
fi

first_image_to_keep="$1"
is_header=1
docker images | sed -e 's/\(\s\)\+/ /g' \
    | while IFS=" " read -r REPOSITORY TAG IMAGE_ID CREATED SIZE
do
    #echo "Repository: $REPOSITORY"
    if [ $is_header -eq 1 ]
    then
        is_header=0
        continue # header row
    fi

    if [[ $REPOSITORY = $first_image_to_keep ]]
    then
        echo "Stopping at first image with name $first_image_to_keep."
        break
    fi
    result="$(docker rmi $IMAGE_ID 2>&1 > /dev/null)"
    if [[ $result = *"being used by stopped container"* ]]
    then
        cont_id=$(echo $result | rev | cut -d' ' -f1 | rev)
        echo "Deleting container $cont_id..."
        docker rm $cont_id
        echo "Deleting image $IMAGE_ID..."
        docker rmi $IMAGE_ID
    fi
done
