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

  it 'add_Issues_As_Nodes (a couple)', ()->
    ids = ['RISK-1', 'RISK-3']
    result = await neo4j_Issues.add_Issues_As_Nodes ids
    result.length.assert_Is_Bigger_Than 0

  it 'add_Issue_As_Nodes (GDPR)', ()->
    id =  "GDPR-329"
    neo4j_Issues.add_Issue_As_Nodes id, (err, result)->
      assert_Is_Null err
      result.size().assert_Is_Bigger_Than 5


  it 'add_Issue_As_Nodes (RISK)', (done)->
    id =  "RISK-424" #RISK-1"
    neo4j_Issues.add_Issue_As_Nodes id, (err, result)->
      assert_Is_Null err
      result.size().assert_Is_Bigger_Than 1
      done()
    return ""   # hack to handle mocha error: Resolution method is overspecified. Specify a callback *or* return a Promise; not both.


  it 'add_Issues_As_Nodes', ()->
    id =  ["GDPR-222", "GDPR-223", "GDPR-225","GDPR-329"]
    result = await neo4j_Issues.add_Issues_As_Nodes id, (err, result)->
    result.size().assert_Is_Bigger_Than 3

  it 'add_Issue_Metatada_As_Nodes', ()->

    id =  "GDPR-223"
    results = await neo4j_Issues.add_Issue_Metatada_As_Nodes id
    results.size().assert_Is_Bigger_Than 25

  it 'add_Issue_Linked_Issues_As_Single_Nodes', ()->
    id =  "GDPR-228"
    #id = "RISK-1"
    neo4j_Issues.add_Issue_Linked_Issues_As_Single_Nodes id, (err, result)->
      result.size().assert_Is_Bigger_Than 6

  it 'add_Linked_Issues_As_Full_Nodes', ()->
    id =  "RISK-1"
    result = await neo4j_Issues.add_Linked_Issues_As_Full_Nodes id
    result.size().assert_Is_Bigger_Than 5
