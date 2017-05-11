#!/usr/bin/env bash

. config/config.sh
. lib/params.sh

if [[ -z "$SCALE" ]]; then
    echo "Scale is not defined"
    exit 1;
fi

echo " Scaling application to ${SCALE} instances"
docker -H ${DOCKER_HOST_DEPLOY} service scale ${APP_NAME}-${APP_ENV}=${SCALE}