echo "*****************************"
echo "*** Building docker image ***"
echo "*****************************"

cd bin/Docker
#docker --no-cache build -t node-hugo         node-hugo/.          || exit 1
docker build --no-cache -t gdpr-patterns-base gdpr-patterns-base/. || exit 1

exit 0

docker build -t diniscruz/gdpr-patterns . || exit 1
#docker build -t diniscruz/gdpr-patterns .

#docker run --rm -it -p 3001:3000 diniscruz/gdpr-patterns bash
#docker run --rm -it -p 3000:3000 diniscruz/gdpr-patterns

docker push diniscruz/gdpr-patterns

exit 0

# command to start the docker instance with specific neo4j server

docker run --rm -it \
           -p 1313:1313 -p 3000:3000 \
           --env Neo4J_Url=bolt://10.8.0.17:7687 --env Neo4J_Username=neo4j --env Neo4J_Password=test \
           diniscruz/gdpr-patterns

export Neo4J_Url=bolt://10.8.0.17:7687
export Neo4J_Username=neo4j
export Neo4J_Password=test