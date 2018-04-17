echo "***************************"
echo "*** Starting Hugo Server ***"
echo "***************************"

cd hugo
hugo serve &
cd ..

node_modules/.bin/nodemon -w ./node/jira-proxy/src/ bin/start-jira-proxy.coffee
