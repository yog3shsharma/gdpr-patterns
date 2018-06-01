# GDPR Patterns

## Installing
1. git clone git@github.com:pbx-gs/gdpr-patterns.git && cd gdp-patterns
2. Install neo4J, hugo 0.36.1, nodeJS v>=8
3. git submodule init && git submodule update  --init --recursive
4. mkdir -p gdpr-patterns-presentation/data && echo -e "url: bolt://localhost:7687\nuser: neo4j\npassword : test" > gdpr-patterns-presentation/data/neo4j_server.yaml
5. npm install


## Running
1. ./bin/start-servers.sh
2. Browse http://localhost:3000/

## Enviroment Variables
    export Jira_Protocol="https"
    export Jira_Host="gdpr-patterns.atlassian.net"
    export Jira_Username=""
    export Jira_Password=""
    export Neo4J_Url="bolt://localhost:7687"
    export Neo4J_Username='neo4j'
    export Neo4J_Password='test' 
    export GIT_HTTP_Url='https://user:pass@bitbucket.org/pbx-gs/public-gdpr-patterns-data.git'
    export GDPR_APP='http://localhost:3000'

## Docker
    1. docker build -t gdpr-patterns:latest bin/docker/gdpr-patterns --no-cache && docker tag gdpr-patterns pbxgs/gdpr-patterns && docker push pbxgs/gdpr-patterns;
    2. docker stop gdpr-patterns; docker rm gdpr-patterns --force;
    3. docker run -d --name gdpr-patterns -p 1313:1313 -p 3000:3000 --env Neo4J_Url=bolt://10.8.0.17:7687 --env Neo4J_Username=neo4j --env Neo4J_Password=test pbxgs/gdpr-patterns


## Docker Data
    1. docker build -t gdpr-patterns-data:latest bin/docker/gdpr-patterns-data --no-cache && docker tag gdpr-patterns-data pbxgs/gdpr-patterns-data && docker push pbxgs/gdpr-patterns-data;
    2. docker stop gdpr-patterns-data; docker rm gdpr-patterns-data --force;
    3. docker run -d --name gdpr-patterns-data  --env --env GIT_HTTP_Url='http://gdpr-patterns:@0.0.0.0:10080/gs/jira-data.git pbxgs/gdpr-patterns-data

