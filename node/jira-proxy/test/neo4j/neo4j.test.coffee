Neo4j       = require '../../src/neo4j/neo4j'
Map_Issues = require '../../../jira-mappings/src/map-issues'

describe 'api | debug', ->
  neo4j = null
  map_Issues = null

  beforeEach ->
    neo4j      =  new Neo4j()
    map_Issues = new Map_Issues()

  it 'constructor', ->
    using neo4j, ->
      @.constructor.name.assert_Is 'Neo4j'
      @.username.assert_Is 'neo4j'
      @.password.assert_Is_String()

  it 'run_Cypher', ()->
    cypher = "match (n) return n"
    neo4j.run_Cypher cypher, {}, (err, response)->
      assert_Is_Null err
      #response.records.assert_Is []
      response.records[0].constructor.name.assert_Is 'Record'

  it 'create_node', ->
    label = 'An_Label'
    params =
      a: 42
      b: 12
    neo4j.create_node label, params, (err, response)->
      assert_Is_Null err
      response.summary.counters._stats.nodesCreated.assert_Is 1

  it 'delete_all_nodes', ()->
    neo4j.delete_all_nodes (err, result)->
      result.records.assert_Is []

  it 'merge_node', ->
    label = 'Merged Node'
    params =
      a: 1000.random()
      b: 1000.random()
    neo4j.merge_node label, params, (err, response)->
      assert_Is_Null err
      response.summary.counters.nodesCreated().assert_Is 1
      neo4j.merge_node label, params, (err, response)->
        assert_Is_Null err
        response.summary.counters.nodesCreated().assert_Is 0


  it 'merge_node', ->
    key = "GDPR-225"
    data = map_Issues.issue key
    label = "RISK"
    result = await neo4j.merge_node(label, data)
    result.records.assert_Size_Is 1

  it 'add_node',->
      label = "RISK"
      key   = "RISK-3"
      result = await neo4j.add_node(label, key)
      result.records.assert_Size_Is 1

  it 'add_node_and_connection',->
    options =
      source_label :'Test-Node'
      source_key   : 42
      target_label :'Test-Node'
      target_key   : 1000.random()
      edge_label   : 'An edge'

    neo4j.add_node_and_connection options, (err, response)->
      assert_Is_Null err
      response.summary.counters.relationshipsCreated().assert_Is 1
      response.summary.counters.nodesCreated()

  it 'params_For_Query', ->
    neo4j.params_For_Query(a:42, b:12).assert_Is "{a:{a},b:{b}}"

