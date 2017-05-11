#!/bin/bash

echo "Starting Base script ..."

cd $(dirname $0)

echo "Obtaining configuration files"
if [[ ! -e config/application.yml ]];then
    [[ ! -e config ]] && mkdir config
    aws s3 cp s3://testability-config/testability/application.yml config/ || true
    aws s3 cp s3://testability-config/testability/application-${APP_ENV}.yml config/
    aws s3 cp s3://testability-config/testability/logback-spring-${APP_ENV}.xml config/logback-spring.xml || true
fi

echo "Starting application"
java -Djava.security.egd=file:/dev/./urandom -jar -Dspring.profiles.active=${APP_ENV} ./app.jar
