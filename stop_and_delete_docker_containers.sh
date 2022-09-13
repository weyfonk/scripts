# Stops and deletes Docker containers based on a keyword

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <KEYWORD>"
    exit 1
fi

IFS=$'\n' arr=($(docker container ls | grep $1 | awk '{print $1}'))

for c in ${arr[@]}; do
    docker stop $c
    docker rm $c
done
