FROM    node:9.10.1

RUN     git clone https://github.com/pbx-gs/gdpr-patterns.git
WORKDIR gdpr-patterns
RUN     sed -ie 's/git@github.com:/https:\/\/github.com\//' .gitmodules
RUN     git submodule init                      && \
        git submodule update                    && \
        npm install

RUN    apt-get update && apt-get install vim -y
ENV     HUGO_VERSION 0.36.1
ENV     HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.deb

ADD     https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} /tmp/hugo.deb
RUN     dpkg -i /tmp/hugo.deb                   && \
	    rm /tmp/hugo.deb

RUN     git pull origin ; # trigger update 12345677

EXPOSE 3000 1313

CMD bin/start-servers.sh

#RUN node_modules/.bin/coffee bin/start-jira-proxy.coffee
