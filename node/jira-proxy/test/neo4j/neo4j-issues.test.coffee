Neo4j_Issues = require '../../src/neo4j/neo4j-issues'

describe 'api | debug', ->
  neo4j_Issues = null

  beforeEach ->
    neo4j_Issues =  new Neo4j_Issues()

  it 'constructor', ->
    neo4j_Issues.constructor.name.assert_Is 'Neo4j_Issues'

  it 'add_Issue', ->
    id = 'RISK-1'
    neo4j_Issues.add_Issue id, (err, data)->
      assert_Is_Null err
      data.records[0].length.assert_Is 1

  it.only 'add_Issues', (done)->
    ids = ['RISK-1', 'RISK-3']
    neo4j_Issues.add_Issues ids, (err, data)-> 
      assert_Is_Null err
      console.log data.assert_Is ids
      done()
