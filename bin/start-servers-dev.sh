echo "********************************************"
echo "*** Starting Hugo Server in Dev mode     ***"
echo "********************************************"

cd hugo
hugo serve  &
cd ..

node_modules/.bin/nodemon         \
    -w ./node/jira-proxy/src/     \
    -w ./node/jira-issues/src/    \
    -w ./node/jira-mappings/src/  \
    bin/start-jira-proxy.coffee $(pwd)/config.json
