#!/bin/bash
PREFIX="soarc-"
API_URL="api-endpoint"
DATABASE_URL="database-mock"
SERVICE_PROXY_URL="service-proxy"
VERSION="latest"
# load rest from env:
USER=$DOCKER_USER
PASSWORD=$DOCKER_PASSWORD

API_STRING="${USER}/${PREFIX}${API_URL}:${VERSION}"
DATABASE_STRING="${USER}/${PREFIX}${DATABASE_URL}:${VERSION}"
SERVICE_PROXY_STRING="${USER}/${PREFIX}${SERVICE_PROXY_URL}:${VERSION}"

echo $PASSWORD | docker login --username=$USER --password-stdin

cd $API_URL
docker build -t $API_STRING . -f Dockerfile
docker push $API_STRING
cd ../$DATABASE_URL
docker build -t $DATABASE_STRING  . -f Dockerfile
docker push $DATABASE_STRING
cd ../$SERVICE_PROXY_URL
docker build -t $SERVICE_PROXY_STRING . -f Dockerfile
docker push $SERVICE_PROXY_STRING
