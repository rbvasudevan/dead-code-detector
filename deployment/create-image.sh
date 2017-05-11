#! /bin/bash

set -e

. config/config.sh
. lib/params.sh
. lib/setEnv.sh
. lib/queryAppStatus.sh

if [[ "${APP_MODULE_NAME}" == "" ]]; then
  echo "Module name not defined"
  exit 1
fi

export MODULE_DIR=$(cd ../$APP_MODULE_NAME && pwd)

if [[ -e $MODULE_DIR/build.gradle ]]; then
    echo 'Preparing java module'
    export DOCKER_FILE_DIR=$DEPLOYMENT_DIR;

    [[ -e $DEPLOYMENT_DIR/app ]] && rm -rf $DEPLOYMENT_DIR/app
    mkdir -p $DEPLOYMENT_DIR/app

    echo 'Copying files to app dir'
    APP_MODULE_JAR=$(ls $MODULE_DIR/build/libs/*.jar | head -1)
    cp $APP_MODULE_JAR $DEPLOYMENT_DIR/app/app.jar
    cp -rf $DEPLOYMENT_DIR/resources/* $DEPLOYMENT_DIR/app/
    echo 'Done'

elif [[ -e $MODULE_DIR/Dockerfile ]];then
    echo "Preparing module image using $MODULE_DIR/Dockerfile"
    export DOCKER_FILE_DIR=$MODULE_DIR;
fi

if [[ $IMAGE_EXISTS == "true" ]];then
    echo 'Backing up docker image'
    docker $DOCKER_HOST_BUILD_MINUS_H tag ${REGISTRY}/${APP_NAME}:${APP_ENV} ${REGISTRY}/${APP_NAME}:${APP_ENV}-backup
    docker $DOCKER_HOST_BUILD_MINUS_H rmi ${REGISTRY}/${APP_NAME}:${APP_ENV}
    echo 'Done'
fi
echo "Generating new image ${APP_NAME}:$APP_ENV"
cd $DOCKER_FILE_DIR
docker $DOCKER_HOST_BUILD_MINUS_H build --no-cache -t ${REGISTRY}/${APP_NAME}:${APP_ENV} $DOCKER_FILE_DIR
echo "Image ${APP_NAME}:${APP_ENV} generated!"

echo "Pushing the image ${APP_NAME}:${APP_ENV} to registry ${REGISTRY}"
docker $DOCKER_HOST_BUILD_MINUS_H push ${REGISTRY}/${APP_NAME}:${APP_ENV}
echo "Pushed to registry ${REGISTRY}"

[[ -e $DEPLOYMENT_DIR/app ]] && rm -rf $DEPLOYMENT_DIR/app || true
