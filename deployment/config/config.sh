#!/usr/bin/env bash


unset APP_NAME
unset REGISTRY
unset DOCKER_HOST
unset DOCKER_HOST_BUILD


export APP_ENV="dev"
export REGISTRY="registry2.swarm.devfactory.com/devfactory"
export DOCKER_HOST_DEPLOY="tcp://webserver.devfactory.com"
export DOCKER_HOST_BUILD="tcp://build.swarm.devfactory.com"


export APP_NAME="${APP_MODULE_NAME}-java"
export DEPLOYMENT_DIR=$([[ "$0" != '-bash' ]] && (cd `dirname $0`; pwd) || pwd)
export APP_ROOT_DIR=$(cd $DEPLOYMENT_DIR; cd ..; pwd)

