#!/usr/bin/env bash

set -e

source config/config.sh
source $HOME/.testability/testability-vars.sh
source lib/params.sh

if [[ -z "$APP_PORT" ]]; then
    eval "export APP_PORT=\$${APP_MODULE_NAME//-/_}_PORT"
    if [[ -z "$APP_PORT" ]]; then
        echo "Application port is not defined"
        show_help
        exit 1
    fi
fi
if [[ -z "$AWS_ACCESS_KEY_ID" ]]; then
    echo "AWS_ACCESS_KEY_ID variable is not defined"
    exit 1
fi
if [[ -z "$AWS_SECRET_ACCESS_KEY" ]]; then
    echo "AWS_SECRET_ACCESS_KEY variable is not defined"
    exit 1
fi

[[ -e $DEPLOYMENT_DIR/app ]] && rm -rf $DEPLOYMENT_DIR/app
mkdir -p $DEPLOYMENT_DIR/app

echo 'Copying files to temp file'
APP_MODULE_JAR=$(ls ../$APP_MODULE_NAME/build/libs/*.jar | head -1)
cp $APP_MODULE_JAR $DEPLOYMENT_DIR/app/app.jar
cp -rf $DEPLOYMENT_DIR/resources/* $DEPLOYMENT_DIR/app/
mkdir $DEPLOYMENT_DIR/app/config
[[ -f $HOME/.testability/application-${APP_ENV}.yml ]] && cp $HOME/.testability/application-${APP_ENV}.yml $DEPLOYMENT_DIR/app/config/application.yml
echo 'Done'

echo "Removing old container instance ${APP_NAME}:${APP_ENV}"
docker stop ${APP_NAME}-${APP_ENV} || true
docker rm ${APP_NAME}-${APP_ENV} || true
echo "Removing old image image ${APP_NAME}:${APP_ENV}"
docker rmi ${APP_NAME}:${APP_ENV} || true
echo "Generating new image ${APP_NAME}:${APP_ENV}"
docker build --no-cache -t ${APP_NAME}:${APP_ENV} $DEPLOYMENT_DIR
echo "Image ${APP_NAME}:${APP_ENV} generated!"

[[ -e $DEPLOYMENT_DIR/app ]] && rm -rf $DEPLOYMENT_DIR/app

echo "  Starting server from image ${APP_NAME}:${APP_ENV}"
docker run -d \
     --name=${APP_NAME}-${APP_ENV} \
     --publish ${APP_PORT}:8080 \
     --env APP_ENV=${APP_ENV} \
     --env AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
     --env AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
     --env HOST_IP=$(ip route list | awk '/default/ {print $3}') \
     ${APP_NAME}:${APP_ENV}

echo "Done."

docker logs -f ${APP_NAME}-${APP_ENV}

