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

  it 'create_node', ->
    label = 'An_Label'
    params =
      a: 42
      b: 12
    neo4j.create_node label, params, (err, response)->
      assert_Is_Null err
      response.summary.counters._stats.nodesCreated.assert_Is 1

  xit 'delete_all_nodes', (done)->
    neo4j.delete_all_nodes (err, result)->
      assert_Is_Null err
      result.records.assert_Is []