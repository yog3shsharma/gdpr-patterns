#!/bin/bash

# Stop if is running
docker stop gdpr-patterns; docker rm gdpr-patterns --force;

# Download latest version from Docker Hub Repo
docker pull pbxgs/gdpr-patterns;

# Run it :)
docker run -d\
	 --name gdpr-patterns\
	 -p 1313:1313\
	 -p 3000:3000\
	 --env Jira_Host=jira.photobox.com\
	 --env Jira_Username=jira.api\
	 --env Jira_Password=****\
	 --env Neo4J_Url=bolt://10.8.0.17:7687\
	 --env Neo4J_Username=neo4j\
	 --env Neo4J_Password=test\
	 pbxgs/gdpr-patterns

# Do i need them? 
export Neo4J_Url=bolt://10.8.0.17:7687
export Neo4J_Username=neo4j
export Neo4J_Password=test

