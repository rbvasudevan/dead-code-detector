#!/usr/bin/env bash

set -e

. config/config.sh
. lib/params.sh
. lib/setEnv.sh
. lib/queryAppStatus.sh



if [[ "$APP_EXISTS" == "false" ]];then
	echo 'Service is not available.'
	exit 1
fi

echo "Getting first service instance"
FIRST_SERVICE=$(docker $DOCKER_HOST_DEPLOY_MINUS_H service ps ${APP_NAME}-${APP_ENV} | grep Running | head -2 | tail -1)
echo $FIRST_SERVICE
echo "--------"

echo "Getting node info"
NODE_ID=$(echo $FIRST_SERVICE | awk -F' ' '{print $4}')
echo "Node objectId: ${NODE_ID}"
echo "--------"

NODE_LS=$(docker -H $DOCKER_HOST_DEPLOY node ls | grep $NODE_ID)
echo $NODE_LS
echo "--------"

NODE_IP=$(echo $NODE_LS | awk -F' ' '{print $2}' | awk -F'-' '{print $2"."$3"."$4"."$5}')
echo "Node IP: ${NODE_IP}"
echo "--------"

echo "Querying docker node for instances"
DOCKER_PS=$(docker -H $NODE_IP ps -a | grep ${APP_NAME}-${APP_ENV})
echo $DOCKER_PS
echo "--------"

DOCKER_ID=$(echo $DOCKER_PS | awk '{print $1}')
echo "First container objectId: ${DOCKER_ID}"
echo "--------"

echo "Going to execute:"
echo "docker -H $NODE_IP logs --tail 100 -f $DOCKER_ID"
docker -H $NODE_IP logs --tail 100 -f $DOCKER_ID
