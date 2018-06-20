echo "***************************"
echo "*** Starting Hugo Server ***"
echo "***************************"

# Remove Data folder
rm -rf data;
echo "Data folder deleted"

# Clone JIRA tickets from JIRA (based on env variable)
git clone $GIT_HTTP_Url data
echo "JIRA tickets copied locally from remote GIT"

echo "Starting HUGO"
cd gdpr-patterns-presentation
hugo serve --bind 0.0.0.0 --watch=false &
echo "Hugo started"
cd ..


echo "Starting Application"
node_modules/.bin/nodemon         \
    -w ./node/jira-proxy/src/     \
    -w ./node/jira-issues/src/    \
    -w ./node/jira-mappings/src/  \
    bin/start-jira-proxy.coffee $(pwd)/config.json
