#! /bin/bash

set -e

. config/config.sh
. lib/params.sh
. lib/setEnv.sh


docker -H ${DOCKER_HOST_DEPLOY} service rm ${APP_NAME}-${APP_ENV}