echo "*****************************"
echo "*** Building docker image ***"
echo "*****************************"

cd bin/Docker
#docker --no-cache build -t node-hugo               node-hugo/.          || exit 1
#docker build --no-cache -t gdpr-patterns-base      gdpr-patterns-base/. || exit 1
docker build  --no-cache -t diniscruz/gdpr-patterns gdpr-patterns        || exit 1

docker push diniscruz/gdpr-patterns

exit 0

# command to ssh into the gdpr-patterns docker image

#docker run --rm -it -p 3001:3000 diniscruz/gdpr-patterns bash

# command to run the gdpr-patterns image

#docker run --rm -it -p 3000:3000 diniscruz/gdpr-patterns


# command to start the docker instance with specific neo4j server

docker run --rm -it \
           -p 1313:1313 -p 3000:3000 \
           --env Neo4J_Url=bolt://10.8.0.17:7687 --env Neo4J_Username=neo4j --env Neo4J_Password=test \
           diniscruz/gdpr-patterns

export Neo4J_Url=bolt://10.8.0.17:7687
export Neo4J_Username=neo4j
export Neo4J_Password=test