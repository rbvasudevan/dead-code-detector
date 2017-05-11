#!/bin/bash

echo "Starting Base script ..."
echo "Starting application"
chmod 777 -r /var/app/app.jar
java -Djava.security.egd=file:/dev/./urandom -jar -Dspring.profiles.active=dev /var/app/app.jar
