#neo4j   = require('neo4j');
neo4j = require('neo4j-driver').v1;
Config  = require '../../../jira-issues/src/config'

class Neo4j
  constructor:->
    @.username = Config.neo4j.username
    @.password = Config.neo4j.password

  run_Cypher: (cypher, params, callback)=>
    uri  = "http://#{@.username}:#{@.password}@localhost:7474')"
    driver = neo4j.driver("bolt://localhost", neo4j.auth.basic(@.username, @.password))

    session = driver.session()

    session.run(cypher, params)
      .then  (result)->
        callback null,result
        session.close();
      .catch  (error)->
        callback error, null

  create_node: (label, params, callback)=>
    label = label.replace '-','_'
    cypher = "CREATE (u:#{label}) SET u = {params} RETURN u"
    @.run_Cypher cypher, params: params, callback

  delete_all_nodes: (callback)=>
    @.run_Cypher "MATCH (n) DETACH DELETE n", {}, callback

module.exports = Neo4j