echo "********************************************"
echo "*** Starting Hugo Server in Dev mode     ***"
echo "********************************************"

mkdir -p data;
mkdir -p data/Mappings;
touch data/Mappings/tracked_queries.json;
touch data/Mappings/issue-files.json;
touch data/Mappings/tracked_queries.json;
touch data/Mappings/issues-by-properties.json;
touch data/Mappings/issues-by-key.json;

time git clone ssh://git@10.8.0.17:10022/gs/jira-data.git data
cd data
git pull
cd ..

cd gdpr-patterns-presentation
hugo serve  &
cd ..

node_modules/.bin/nodemon         \
    -w ./node/jira-proxy/src/     \
    -w ./node/jira-issues/src/    \
    -w ./node/jira-mappings/src/  \
    bin/start-jira-proxy.coffee $(pwd)/config.json
