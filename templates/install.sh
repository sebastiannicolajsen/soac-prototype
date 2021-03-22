#!/bin/bash
KEY=$1
IMAGE=$2
PORT=$3
ENV_VARS=$4
USER=$5
IP=$6

TMP_LIST='$(docker ps -q)'

ssh -o "StrictHostKeyChecking no" -i $KEY $USER@$IP "docker kill ${TMP_LIST}; docker pull ${IMAGE} ; echo -e '${ENV_VARS}' > .env ; docker run -dp ${PORT}:${PORT} --env-file .env ${IMAGE}"
