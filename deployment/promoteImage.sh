#!/usr/bin/env bash


. config/config.sh
. lib/params.sh
. lib/setEnv.sh
. lib/queryAppStatus.sh



if [[ $IMAGE_EXISTS == "true" ]];then
	echo 'Backing up docker image'
	docker $DOCKER_HOST_BUILD_MINUS_H tag ${REGISTRY}/${APP_NAME}:${APP_ENV} ${REGISTRY}/${APP_NAME}:${APP_ENV}-backup
	docker $DOCKER_HOST_BUILD_MINUS_H rmi ${REGISTRY}/${APP_NAME}:${APP_ENV}
	echo 'Done'
fi

echo "Promoting docker image from ${APP_SRC_ENV} to ${APP_ENV}"
docker $DOCKER_HOST_BUILD_MINUS_H pull ${REGISTRY}/${APP_NAME}:${APP_SRC_ENV}
docker $DOCKER_HOST_BUILD_MINUS_H tag ${REGISTRY}/${APP_NAME}:${APP_SRC_ENV} ${REGISTRY}/${APP_NAME}:${APP_ENV}
docker $DOCKER_HOST_BUILD_MINUS_H push ${REGISTRY}/${APP_NAME}:${APP_ENV}
echo 'Done'
