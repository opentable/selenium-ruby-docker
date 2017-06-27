#!/bin/sh

set -o errexit -o nounset

REPO=docker.otenv.com/ot-java8
MAVEN_REPO=docker.otenv.com/ot-java8-maven

BRANCH=${1#refs/heads/}
BUILDNUMBER=$2

cd $(dirname $0)

if [ $BRANCH = master ]; then
  TAG=$BUILDNUMBER
else
  TAG=$BRANCH-$BUILDNUMBER
fi

docker pull docker.otenv.com/ot-ubuntu:latest

IMAGE=$REPO:$TAG
docker build --no-cache -t $IMAGE .

if [ $BRANCH = master ]; then
  docker tag -f $IMAGE $REPO:latest
  docker push $REPO:latest
fi

docker push $IMAGE

docker build -t $MAVEN_REPO:$TAG maven
docker push $MAVEN_REPO:$TAG

if [ $BRANCH = master ]; then
  docker tag -f $MAVEN_REPO:$TAG $MAVEN_REPO:latest
  docker push $MAVEN_REPO:latest
fi
