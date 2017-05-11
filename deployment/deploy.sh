#!/usr/bin/env bash

set -e

. config/config.sh
. lib/params.sh
. lib/setEnv.sh
. lib/queryAppStatus.sh

export MODULE_DIR=$(cd ../$APP_MODULE_NAME && pwd)

if [[ -z "$APP_PORT" ]]; then
    echo "Application port is not defined"
    show_help
    exit 1
fi

export MODULE_DIR=$(cd ../$APP_MODULE_NAME && pwd)

if [[ -e $MODULE_DIR/build.gradle ]]; then
    if [[ -z "$AWS_ACCESS_KEY_ID" ]]; then
        echo "AWS_ACCESS_KEY_ID variable is not defined"
        exit 1
    fi
    if [[ -z "$AWS_SECRET_ACCESS_KEY" ]]; then
        echo "AWS_SECRET_ACCESS_KEY variable is not defined"
        exit 1
    fi
fi

echo 'Pulling image'
docker -H ${DOCKER_HOST_BUILD} pull ${REGISTRY}/${APP_NAME}:${APP_ENV}

if [[ $APP_EXISTS == "true" ]];then
    echo 'Service already exists.'

    echo '  Unprovisioning service'
    ./undeploy.sh -e ${APP_ENV} -m ${APP_MODULE_NAME}
    echo '  DONE.'

fi

echo "  Provisioning service from image ${REGISTRY}/${APP_NAME}:${APP_ENV}"
if [[ -e $MODULE_DIR/build.gradle ]]; then
    docker -H ${DOCKER_HOST_DEPLOY} service create \
         --limit-cpu 4 \
         --limit-memory 32G \
         --name=${APP_NAME}-${APP_ENV} \
         --publish ${APP_PORT}:8080 \
         --update-delay 10s \
         --env APP_ENV=${APP_ENV} \
         --env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
         --env AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
           ${REGISTRY}/${APP_NAME}:${APP_ENV}

elif [[ -e $MODULE_DIR/Dockerfile ]];then
    docker -H ${DOCKER_HOST_DEPLOY} service create \
         --limit-cpu 4 \
         --limit-memory 32G \
         --name=${APP_NAME}-${APP_ENV} \
         --publish ${APP_PORT}:8080 \
         --update-delay 10s \
         --env APP_ENV=${APP_ENV} \
           ${REGISTRY}/${APP_NAME}:${APP_ENV}
fi

if [[ "${SCALE}" != "" ]]; then
    echo " Scaling application to ${SCALE} instances"
    docker -H ${DOCKER_HOST_DEPLOY} service scale ${APP_NAME}-${APP_ENV}=${SCALE}
fi

echo "Done."

