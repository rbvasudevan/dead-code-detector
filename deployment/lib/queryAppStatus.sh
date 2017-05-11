#!/bin/bash


echo 'Looking for created images'
IMAGE_EXISTS=$(
    docker $DOCKER_HOST_BUILD_MINUS_H images | awk -F' ' '{print $1":"$2}' | grep -e ${APP_NAME}:${APP_ENV}$ &> /dev/null && \
    echo "true" || \
    echo "false"
)

echo 'Looking for deployed services'
APP_EXISTS=$(
    docker $DOCKER_HOST_DEPLOY_MINUS_H service ps ${APP_NAME}-${APP_ENV} &> /dev/null && \
    echo "true" || \
    echo "false"
)