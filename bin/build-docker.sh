#!/bin/bash

# Build
docker build -t gdpr-patterns:latest bin/docker_all/ ;

# Tag
docker tag gdpr-patterns pbxgs/gdpr-patterns ;

# Push
docker push pbxgs/gdpr-patterns ;
