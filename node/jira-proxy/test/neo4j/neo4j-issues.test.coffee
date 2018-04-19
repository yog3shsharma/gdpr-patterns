Neo4j_Issues = require '../../src/neo4j/neo4j-issues'
Issues       = require '../../../jira-mappings/src/util/issues'

describe 'api | debug', ->
  neo4j_Issues = null
  issues       = null

  beforeEach ->
    neo4j_Issues =  new Neo4j_Issues()
    issues       =  new Issues()

  afterEach ->
    driver = neo4j_Issues.neo4j.driver()
    driver.close()

  it 'constructor', ->
    neo4j_Issues.constructor.name.assert_Is 'Neo4j_Issues'

  xit 'add_Issue', ->
    id = 'RISK-1'
    neo4j_Issues.add_Issue id, (err, data)->
      assert_Is_Null err
      data.records[0].length.assert_Is 1

  it 'add_Issues (a couple)', (done)->
    ids = ['RISK-1', 'RISK-3']
    neo4j_Issues.add_Issues ids, (err, data)->
      assert_Is_Null err
      data.assert_Is ids
      done()

  it 'add_Issues (n)', (done)->
    #@timeout 4000
    count = 50
    ids = issues.ids().take(count)
    neo4j_Issues.add_Issues ids, (err, data)->
      assert_Is_Null err
      data.size().assert_Is_Bigger_Than 10
      done()

  it.only 'add_Issue_As_Nodes', (done)->
    id =  "GDPR-223"
    neo4j_Issues.add_Issue_Metatada_As_Nodes id, (err, result)->
      console.log err
      console.log result.size()

      done()
