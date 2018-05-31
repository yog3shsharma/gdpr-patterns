echo "**************************************************"
echo "***  Starting DATA Server in Dev mode - DATA   ***"
echo "**************************************************"

node_modules/.bin/nodemon \
    -w  ./node/jira-proxy/src/  \
    -w ./node/jira-issues/src/  \
    -w ./node/jira-mappings/src/ \
    bin/track-jira-data.coffee  $(pwd)/config.json