#!/usr/bin/env bash

set -ev

SCRIPT_DIR=$(dirname "$0")

if [[ -z "$GROUP" ]] ; then
    echo "Cannot find GROUP env var"
    exit 1
fi

if [[ -z "$COMMIT" ]] ; then
    echo "Cannot find COMMIT env var"
    exit 1
fi

if [[ "$(uname)" == "Darwin" ]]; then
    DOCKER_CMD=docker
else
    DOCKER_CMD="sudo docker"
fi
CODE_DIR=$(cd $SCRIPT_DIR/..; pwd)
echo $CODE_DIR


# I don't like this bit, but I'm leaving it in for consistency with old versions.
module=login
REPO=${GROUP}/${module}
$DOCKER_CMD build -t ${REPO}-dev:${COMMIT} .;
$DOCKER_CMD create --name ${module} ${REPO}-dev;
$DOCKER_CMD cp ${module}:/app/main ./app;
$DOCKER_CMD rm ${module};
cp app ./docker/login
cp users.json ./docker/login

for m in ./docker/*/; do
    REPO=${GROUP}/$(basename $m)
    $DOCKER_CMD build -t ${REPO}:${COMMIT} $CODE_DIR/$m;
done;


