#! /bin/bash

set -e

. config/config.sh

echo "Building project..."
cd $APP_ROOT_DIR && chmod a+x gradlew && ./gradlew clean build 
echo 'Build done!'


