#! /bin/bash

set -e

. config/config.sh
. lib/params.sh
. lib/setEnv.sh


docker -H ${DOCKER_HOST_DEPLOY} service ps ${APP_NAME}-${APP_ENV}