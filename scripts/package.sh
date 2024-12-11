#!/bin/bash
set -ev

# build dotnet application

dotnet publish ./src/Service.Host/ -c release
# dotnet publish ./src/Messaging.Host/ -c release
# dotnet publish ./src/Scheduling.Host/ -c release

# determine which branch this change is from
if [ "${TRAVIS_PULL_REQUEST}" = "false" ]; then
  GIT_BRANCH=$TRAVIS_BRANCH
else
  GIT_BRANCH=$TRAVIS_PULL_REQUEST_BRANCH
fi

# create docker image(s)
docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD
docker build --no-cache -t linn/visitors:$TRAVIS_BUILD_NUMBER --build-arg gitBranch=$GIT_BRANCH ./src/Service.Host/
# docker build --no-cache -t linn/visitors-messaging:$TRAVIS_BUILD_NUMBER --build-arg gitBranch=$GIT_BRANCH ./src/Messaging.Host/
# docker build --no-cache -t linn/visitors-scheduling:$TRAVIS_BUILD_NUMBER --build-arg gitBranch=$GIT_BRANCH ./src/Scheduling.Host/

# push to dockerhub 
docker push linn/visitors:$TRAVIS_BUILD_NUMBER
# docker push linn/visitors-messaging:$TRAVIS_BUILD_NUMBER
# docker push linn/visitors-scheduling:$TRAVIS_BUILD_NUMBER
