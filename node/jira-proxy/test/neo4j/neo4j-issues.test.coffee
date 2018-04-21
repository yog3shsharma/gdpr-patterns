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

  xit 'add_Issues (a couple)', (done)->
    ids = ['RISK-1', 'RISK-3']
    neo4j_Issues.add_Issues ids, (err, data)->
      assert_Is_Null err
      data.assert_Is ids
      done()

  xit 'add_Issues (n)', (done)->
    #@timeout 4000
    count = 50
    ids = issues.ids().take(count)
    neo4j_Issues.add_Issues ids, (err, data)->
      assert_Is_Null err
      data.size().assert_Is_Bigger_Than 10
      done()

  it 'add_Issue_As_Nodes (GDPR)', (done)->
    id =  "GDPR-329"
    neo4j_Issues.add_Issue_As_Nodes id, (err, result)->
      assert_Is_Null err
      result.size().assert_Is_Bigger_Than 10
      done()

  it.only 'add_Issue_As_Nodes (RISK)', (done)->
    id =  "RISK-424" #RISK-1"
    neo4j_Issues.add_Issue_As_Nodes id, (err, result)->
      assert_Is_Null err
      result.size().assert_Is_Bigger_Than 10
      done()
    return ""   # hack to handle mocha error: Resolution method is overspecified. Specify a callback *or* return a Promise; not both.


  it 'add_Issues_As_Nodes', (done)->
    id =  ["GDPR-222", "GDPR-223", "GDPR-225","GDPR-329"]
    neo4j_Issues.add_Issues_As_Nodes id, (err, result)->
      assert_Is_Null err
      console.log result.size()
      result.size().assert_Is_Bigger_Than 10
      done()

  it 'add_Issue_Metatada_As_Nodes', (done)->
    id =  "GDPR-223"
    neo4j_Issues.add_Issue_Metatada_As_Nodes id, (err, result)->
      assert_Is_Null err
      result.size().assert_Is_Bigger_Than 10
      done()

  it.only 'add_Issue_Linked_Issues_As_Single_Nodes', (done)->
    id =  "GDPR-228"
    #id = "RISK-1"
    neo4j_Issues.add_Issue_Linked_Issues_As_Single_Nodes id, (err, result)->
      console.log err
      console.log result.size().assert_Is_Bigger_Than 6
      done()

  it 'add_Linked_Issues_As_Full_Nodes', (done)->
    id =  "GDPR-223"
    neo4j_Issues.add_Linked_Issues_As_Full_Nodes id, (err, result)->
      result.size().assert_Is_Bigger_Than 200
      done()
