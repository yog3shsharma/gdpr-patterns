# GDPR Patterns

## Installing
    1. git clone git@github.com:pbx-gs/gdpr-patterns.git
    2. cd gdp-patterns
    3. git submodule init 
    4. git submodule update  --init --recursive
    5. npm install
    6. Install neo4J, hugo and nodeJS 
    7. Start Neo4J (keep in mind URL, username and password)
    8. Edit the file "config.json" 
    9. echo -e "url: bolt://localhost:7687\nuser: neo4j\npassword : test"> gdpr-patterns-presentation/data/neo4j_server.yaml
## Running
    1. ./bin/start-servers.sh
    2. Browse http://localhost:3000/



