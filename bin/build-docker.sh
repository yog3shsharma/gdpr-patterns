#!/bin/bash

# Build
docker build -t gdpr-patterns:latest bin/docker_all/ --no-cache;
docker build -t gdpr-patterns-data:latest bin/docker/gdpr-patterns-data --no-cache;

# Tag
docker tag gdpr-patterns pbxgs/gdpr-patterns ;
docker tag gdpr-patterns-data pbxgs/gdpr-patterns-data ;

# Push
docker push pbxgs/gdpr-patterns ;
docker push pbxgs/gdpr-patterns-data ;
