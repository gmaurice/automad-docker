#!/bin/bash
REPO=$1
BRANCH=$2

[ -z "$REPO" ] && echo "Please provide repository name 'username/repository'." && echo "Exiting..." && exit 1
[ -z "$BRANCH" ] && BRANCH=master


docker ps -q --filter ancestor="laires/automad:latest" | xargs docker stop
docker ps -a -q --filter ancestor="laires/automad:latest" | xargs docker rm 

docker rmi laires/automad:latest

if [ -d ./automad ];
then
    echo "Building from local[$BRANCH]"
    cd ./automad
    git switch $BRANCH
    git pull origin $BRANCH
    cd ..
else
    echo "Building from $REPO[$BRANCH]"
    git clone https://github.com/$REPO automad
    cd ./automad
    git switch $BRANCH
    cd ..
fi

docker build --no-cache -t laires/automad .
docker run -d -p 8000:80 --name automad-latest laires/automad:latest 

docker images
