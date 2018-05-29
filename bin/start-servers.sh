echo "***************************"
echo "*** Starting Hugo Server ***"
echo "***************************"


cd gdpr-patterns-presentation
hugo serve --bind 0.0.0.0 --watch=false &
cd ..

node_modules/.bin/nodemon         \
    -w ./node/jira-proxy/src/     \
    -w ./node/jira-issues/src/    \
    -w ./node/jira-mappings/src/  \
    bin/start-jira-proxy.coffee $(pwd)/config.json
