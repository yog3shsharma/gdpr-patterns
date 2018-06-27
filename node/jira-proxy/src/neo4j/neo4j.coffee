#neo4j   = require('neo4j');
neo4j = require('neo4j-driver').v1;
Config  = require '../../../jira-issues/src/config'

_driver = null
_session = null

class Neo4j
  constructor:->
    @.username = Config.neo4j.username
    @.password = Config.neo4j.password
    @.url      = Config.neo4j.url

  driver: ()=>
    if not _driver
      _driver =   neo4j.driver(@.url , neo4j.auth.basic(@.username, @.password))
    return _driver

  session1: ()=>
    if not _session
      _session =  @.driver().session()
    return _session
    
  run_Cypher_Single_Session: (cypher, params, callback)=>
    session = @.session1()
    session.run(cypher, params)
      .then  (result)->
        #session.close();
        #callback? null,result
        #return result
      .catch  (error)->
        callback? error, null
        return error

  run_Cypher: (cypher, params, callback)=>

    session = @.driver().session()

    session.run(cypher, params)
      .then  (result)->
        session.close();
        callback? null,result
        return result
      .catch  (error)->
        callback? error, null
        return error


  create_node: (label, params, callback)=>
    label = label.replace('-','_').replace(' ', '_')
    cypher = "CREATE (u:#{label}) SET u = {params} RETURN u"
    @.run_Cypher cypher, params: params, callback

  delete_all_nodes: (callback)=>
    @.run_Cypher "MATCH (n) DETACH DELETE n", {}, callback

  merge_node: (label, raw_Params, callback)=>
    params = {}
    for key, value of raw_Params            # we need to replace all keys with the safe field name
      if key isnt "Linked Issues"
        key = key.to_Safe_String().replace(/\s/g,'_').replace(/-/g,'_')
        params[key] = value
    try
      label = label.replace('-','_').replace(' ', '_')
    catch e 
      label = 'underfined'
    params_query = @.params_For_Query(params)
    cypher = "MERGE (u:#{label} #{params_query})  RETURN u"
    @.run_Cypher cypher, params, callback

  add_Edge: (source_label, source_key, edge_label, target_label, target_key)->
    options =
      source_label : source_label
      source_key   : source_key
      edge_label   : edge_label
      target_label : target_label
      target_key   : target_key
    #console.log(options)
    @.add_node_and_connection options

  add_Edge2: (source_key, edge_label, target_key)->
    options =
      source_key   : source_key
      edge_label   : edge_label
      target_key   : target_key
    #console.log(options)
    params = key1: options.source_key, key2 :options.target_key

    edge    = @.label_Format options.edge_label
    cypher = """MERGE (u1 {key: '#{source_key}' } )
                MERGE (u2 {key: '#{target_key}' } )
                MERGE (u1)-[r:#{edge}]->(u2)
                return u1,u2,r"""

    await @.run_Cypher_Single_Session cypher

  add_Node: (label, key)=>
    label = @.label_Format label
    cypher = "MERGE (u1:#{label} {key:{key}} ) return *"
    params = key : key
    @.run_Cypher cypher, params



  add_node_and_connection: (options, callback)->

    params = key1: options.source_key, key2 :options.target_key

    label_1 = @.label_Format options.source_label
    label_2 = @.label_Format options.target_label
    edge    = @.label_Format options.edge_label
    cypher = """MERGE (u1:#{label_1} {key:{key1}} )
                MERGE (u2:#{label_2} {key:{key2}} )
                MERGE (u1)-[r:#{edge}]->(u2)
                return u1,u2,r"""
    #console.log  cypher
    #console.log(cypher)
    @.run_Cypher cypher, params, callback

  label_Format: (text)->
    return "" if not text
    return text.replace(/\s/g, '_').replace(/-/g,'_').replace(/\./g,'_')

  params_For_Query: (params)=>      # move to utils section
    ids = params._keys()
    result = []
    for id in ids
      result.push "#{id}:{#{id}}"
    return '{'+ result.join(",") + '}'



  # DSL methods

  nodes_Count: ()=>
    result = await @.run_Cypher "MATCH (n) RETURN count(n) as count"
    return result.records[0].get("count").toNumber()

  nodes_Keys: ()=>
    result = await @.run_Cypher "MATCH (n) RETURN n.key as key"
    ids = []
    result.records.map (record)->
      ids.push record.get('key')
    return ids

module.exports = Neo4j