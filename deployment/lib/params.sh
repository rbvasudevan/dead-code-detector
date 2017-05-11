#!/usr/bin/env bash


show_help() {
    echo "Usage: build.sh [options]" >&2
    echo "Options:" >&2
    echo "    --help            Help instructions." >&2
    echo "-R, --registry        Image Registry Host." >&2
    echo "-r, --replicas        Number of instances." >&2
    echo "-h, --host            Docker Daemon Host to Deploy." >&2
    echo "-b, --build           Docker Daemon Build Host to Deploy." >&2
    echo "-s, --srcenv          Source environment to config to use: prod|dev|stg." >&2
    echo "-e, --env             Environment to config to use: prod|dev|stg." >&2
    echo "-m, --module-name     Application module to be build." >&2
    echo "-p, --port            External Port to be used in the Docker host." >&2
    echo "-i, --instnum         Number of instances to scale." >&2
    exit 0
}

while :; do
    case $1 in
        -R|--registry)
            if [ -n "$2" ]; then
                REGISTRY=$2
            else
                printf 'No registry host provided.\n' >&2
                show_help
            fi
            shift
        ;;
        -r|--replicas)
            if [ -n "$2" ]; then
                REPLICAS=$2
            else
                printf 'No replicas provided.\n' >&2
                show_help
            fi
            shift
        ;;
        -h|--host)
            if [ -n "$2" ]; then
                DOCKER_HOST=$2
            else
                printf 'No docker host provided.\n' >&2
                show_help
            fi
            shift
        ;;
        -b|--build)
            if [ -n "$2" ]; then
                DOCKER_HOST_BUILD=$2
            else
                printf 'No docker build host provided.\n' >&2
                show_help
            fi
            shift
        ;;
        -s|--srcenv)
            if [ -n "$2" ]; then
                APP_SRC_ENV=$2
            else
                printf 'No SOURCE environment provided.\n' >&2
                show_help
            fi
            shift
        ;;
        -e|--env)
            if [ -n "$2" ]; then
                APP_ENV=$2
            else
                printf 'No environment provided.\n' >&2
                show_help
            fi
            shift
        ;;
        -m|--module-name)
            if [ -n "$2" ]; then
                APP_MODULE_NAME=$2
            else
                printf 'No module name provided.\n' >&2
                show_help
            fi
            shift
        ;;
        -p|--port)
            if [ -n "$2" ]; then
                APP_PORT=$2
            else
                printf 'No port provided.\n' >&2
                show_help
            fi
            shift
        ;;
        -i| --instnum)
            if [ -n "$2" ]; then
                SCALE=$2
            else
                printf 'No instance number provider.\n' >&2
                show_help
            fi
            shift
        ;;
        --help)
            show_help
        ;;
        --) # End of all options.
            shift
            break
        ;;
        -?*)
            printf c
            show_help
        ;;
        *) # Default case: If no more options then break out of the loop.
            break
    esac
    shift
done

if [[ -z "$APP_ENV" ]];then
  echo "Environment not defined"
  show_help
  exit 1
fi
if [[ -z "$APP_MODULE_NAME" ]];then
  echo "Module name not defined"
  show_help
  exit 1
fi

export APP_NAME=$APP_MODULE_NAME
if [[ -e ../${APP_MODULE_NAME}/build.gradle ]];then
    export APP_NAME="${APP_NAME}-java"
fi

export DOCKER_HOST_BUILD_MINUS_H=$( [[ ${DOCKER_HOST_BUILD} != "" ]] && echo "-H ${DOCKER_HOST_BUILD}" );
export DOCKER_HOST_DEPLOY_MINUS_H=$( [[ ${DOCKER_HOST_DEPLOY} != "" ]] && echo "-H ${DOCKER_HOST_DEPLOY}" );