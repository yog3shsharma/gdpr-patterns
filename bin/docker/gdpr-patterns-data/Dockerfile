FROM    node:9.10.1

RUN     apt-get update && apt-get install apt-utils vim -y
#ENV     HUGO_VERSION 0.36.1
#ENV     HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.deb

#ADD     https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} /tmp/hugo.deb
#RUN     dpkg -i /tmp/hugo.deb                   && \
#	    rm /tmp/hugo.deb

RUN     git clone https://github.com/pbx-gs/gdpr-patterns.git
WORKDIR gdpr-patterns
#RUN     sed -ie 's/git@github.com:/https:\/\/github.com\//' .gitmodules
#RUN     git submodule init                      && \
#        git submodule update                    && \
#        sed -ie 's/git@github.com:/https:\/\/github.com\//' gdpr-patterns-presentation/.gitmodules && \
#        git submodule update --init --recursive && \

RUN     npm install

#RUN     git pull origin

#EXPOSE 3000:3001
#EXPOSE 1313:1314

CMD bin/start-servers-data.sh


# docker login

# 7473, 7474, 7687
# docker ps -a
# docker build -t gdpr-patterns-data:latest bin/docker/gdpr-patterns-data
# docker tag gdpr-patterns-data pbxgs/gdpr-patterns-data
# docker push pbxgs/gdpr-patterns-data
# docker stop gdpr-patterns-data; docker rm gdpr-patterns-data --force;
# docker run -d --name gdpr-patterns-data -p 1313:1314 -p 3000:3001 --env Neo4J_Url=bolt://10.8.0.17:7687 --env Neo4J_Username=neo4j --env Neo4J_Password=test pbxgs/gdpr-patterns-data
# docker pull pbxgs/gdpr-patterns-data