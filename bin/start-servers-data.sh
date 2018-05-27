echo "**************************************************"
echo "***   Starting Hugo Server in Dev mode - DATA  ***"
echo "**************************************************"

cd gdpr-patterns-presentation
hugo serve  &
cd ..

node_modules/.bin/nodemon \
    -w  ./node/jira-proxy/src/  \
    -w ./node/jira-issues/src/  \
    -w ./node/jira-mappings/src/ \
    bin/track-jira-data.coffee  $(pwd)/config.json