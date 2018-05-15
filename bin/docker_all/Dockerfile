FROM    node:9.10.1

RUN     apt-get update && apt-get install apt-utils vim -y
ENV     HUGO_VERSION 0.36.1
ENV     HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.deb

ADD     https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} /tmp/hugo.deb
RUN     dpkg -i /tmp/hugo.deb                   && \
	    rm /tmp/hugo.deb

RUN     git clone https://github.com/pbx-gs/gdpr-patterns.git
WORKDIR gdpr-patterns
RUN     sed -ie 's/git@github.com:/https:\/\/github.com\//' .gitmodules
RUN     git submodule init                      && \
        git submodule update                    && \
        sed -ie 's/git@github.com:/https:\/\/github.com\//' gdpr-patterns-presentation/.gitmodules && \
        git submodule update --init --recursive && \
        npm install

RUN     git pull origin

EXPOSE 3000:3000
EXPOSE 1313:1313

CMD bin/start-servers.sh


# docker build -t gdpr-patterns:latest bin/docker_all/
# docker stop gdpr-patterns-img; docker rm gdpr-patterns-img --force;
# docker run -d --name gdpr-patterns-img -p 1313:1313 -p 3000:3000 gdpr-patterns
