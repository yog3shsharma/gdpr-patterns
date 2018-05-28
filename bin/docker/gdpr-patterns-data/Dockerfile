FROM    node:9.10.1

RUN     apt-get update && apt-get install apt-utils vim -y
RUN     git clone https://github.com/pbx-gs/gdpr-patterns.git
WORKDIR gdpr-patterns
RUN     npm install

CMD bin/start-servers-data.sh

# docker build -t gdpr-patterns-data:latest bin/docker/gdpr-patterns-data --no-cache;
# docker tag gdpr-patterns-data pbxgs/gdpr-patterns-data;
# docker push pbxgs/gdpr-patterns-data;

# docker stop gdpr-patterns-data; docker rm gdpr-patterns-data --force;
# docker run -d --name gdpr-patterns-data -p 1313:1314 -p 3000:3001 --env Neo4J_Url=bolt://localhost:7687 --env Neo4J_Username=neo4j --env Neo4J_Password=test pbxgs/gdpr-patterns-data
# docker pull pbxgs/gdpr-patterns-data