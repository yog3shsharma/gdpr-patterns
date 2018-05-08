FROM    node:9.10.1

RUN     git clone https://github.com/pbx-gs/gdpr-patterns.git
WORKDIR gdpr-patterns
RUN     pwd
RUN     ls -la
RUN     sed -ie 's/git@github.com:/https:\/\/github.com\//' .gitmodules
RUN     git submodule init                      && \
        git submodule update                    && \
        npm install


RUN node_modules/.bin/coffee bin/start-jira-proxy.coffee
