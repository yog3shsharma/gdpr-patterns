#neo4j   = require('neo4j');
neo4j = require('neo4j-driver').v1;
Config  = require '../../../jira-issues/src/config'

_driver = null

class Neo4j
  constructor:->
    @.username = Config.neo4j.username
    @.password = Config.neo4j.password



  driver: ()=>
    if not _driver
      _driver =   neo4j.driver("bolt://localhost", neo4j.auth.basic(@.username, @.password))
    return _driver

  run_Cypher: (cypher, params, callback)=>
    uri  = "http://#{@.username}:#{@.password}@localhost:7474')"

    session = @.driver().session()

    session.run(cypher, params)
      .then  (result)->
        session.close();
        callback null,result
      .catch  (error)->
        callback error, null

  create_node: (label, params, callback)=>
    label = label.replace('-','_').replace(' ', '_')
    cypher = "CREATE (u:#{label}) SET u = {params} RETURN u"
    @.run_Cypher cypher, params: params, callback

  delete_all_nodes: (callback)=>
    @.run_Cypher "MATCH (n) DETACH DELETE n", {}, callback

  merge_node: (label, params, callback)=>
    label = label.replace('-','_').replace(' ', '_')
    params_query = @.params_For_Query(params)
    cypher = "MERGE (u:#{label} #{params_query})  RETURN u"
    @.run_Cypher cypher, params, callback

  # there is a limitation with this script at the moment since it needs the node1 and node2 params titles to be different
  add_node_and_connection: (options, callback)->

    params = Object.assign({}, options.node1.params, options.node2.params)    # merge params
    label_1 = options.node1.label.replace(' ','_').replace('-','_')
    label_2 = options.node2.label.replace(' ','_').replace('-','_')
    cypher = """MERGE (u1:#{label_1} #{@.params_For_Query(options.node1.params)})
                MERGE (u2:#{label_2} #{@.params_For_Query(options.node2.params)})
                MERGE (u1)-[r:#{options.edge}]->(u2)
                return u1,u2,r"""
    #console.log  cypher
    @.run_Cypher cypher, params, callback

  params_For_Query: (params)=>      # move to utils section
    ids = params._keys()
    result = []
    for id in ids
      result.push "#{id}:{#{id}}"
    return '{'+ result.join(",") + '}'

module.exports = Neo4j