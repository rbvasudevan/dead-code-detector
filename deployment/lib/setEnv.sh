#!/usr/bin/env bash


if [ -e ${APP_ENV}-env.sh ]; then
    source ${APP_MODULE_NAME}-${APP_ENV}-env.sh
fi