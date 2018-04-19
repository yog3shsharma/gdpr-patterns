Neo4j = require '../../src/neo4j/neo4j'

describe 'api | debug', ->
  neo4j = null

  beforeEach ->
    neo4j =  new Neo4j()

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

  xit 'create_node', ->
    label = 'An_Label'
    params =
      a: 42
      b: 12
    neo4j.create_node label, params, (err, response)->
      console.log err
      assert_Is_Null err
      response.summary.counters._stats.nodesCreated.assert_Is 1

  xit 'delete_all_nodes', (done)->
    neo4j.delete_all_nodes (err, result)->
      assert_Is_Null err
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

  it 'add_node_and_connection',->
    options =
      node1:
        label: 'Test'
        params:  {a: 1000.random()}
      node2:
        label: 'Test'
        params:  {b: "42"}
      edge: "ABC"
    neo4j.add_node_and_connection options, (err, response)->
      response.summary.counters.relationshipsCreated().assert_Is 1
      response.summary.counters.nodesCreated()

  it 'params_For_Query', ->
    console.log neo4j.params_For_Query(a:42, b:12)

