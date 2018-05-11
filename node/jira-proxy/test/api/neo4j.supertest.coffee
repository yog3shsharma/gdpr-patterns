Supertest = require '../../src/_test-utils/Supertest'

describe 'api | supertest | neo4j', ->
  supertest = null

  request = (path, callback)->
    supertest.request "/api/neo4j/#{path}", callback

  before ->
    supertest = new Supertest()

  it 'cypher', ->
    request 'cypher', (data)->
      data.records.size().assert_Is_Number()

  it 'create', ->
    cypher = 'create/AAAA?aaa=123&bbb=678'
    request cypher, (data)->
      data.records.assert_Is []
      data.summary.statement.text.assert_Is "CREATE (n:AAAA {aaa:'123',bbb:'678'})"


  xit 'delete/all', ()->
    request 'delete/all', (data)->
      data.records.assert_Is []

  it.only 'add-Issue-and-Linked-Nodes',->
    id = 'RISK-10'
    request "nodes/add-Issue-and-Linked-Nodes/#{id}", (data)->
      data.nodes_created.assert_Is_Bigger_Than 0

  it 'add-Issue-and-Linked-Nodes (not found)',->
    id = 'RISK-3'
    request "nodes/add-Issue-and-Linked-Nodes/#{id}", (data)->
      data.assert_Is { nodes_created: 0, results: [] }

  it 'add-Issue-Metatada-as-Nodes', ->
    id = 'RISK-2'
    request "nodes/add-Issue-Metatada-as-Nodes/#{id}", (data)->
      data.nodes_created.assert_Is_Bigger_Than 10

  it 'add-Issue-Metatada-as-Nodes (filter)', ->
    id      = 'RISK-5'
    filters = "Summary,Risk Rating,Rist Owner"
    request "nodes/add-Issue-Metatada-as-Nodes/#{id}?filters=#{filters}", (data)->
      data.nodes_created.assert_Is_Bigger_Than 0

  it 'add-Issues-Metatada-as-Nodes', ->
    regex = 'RISK-100'
    request "nodes/add-Issues-Metatada-as-Nodes/#{regex}", (data)->
      console.log data.nodes_created
      data.nodes_created.assert_Is_Bigger_Than 10

  it 'nodes_Create', ->
    id = 'RISK-1,GDPR-223,GDPR-225,GDPR-226,GDPR-326'
    request "nodes/create/#{id}", (data)->
      data.nodes_created.assert_Is_Bigger_Than 7

  @.timeout 5000
  xit 'create-regex', ->
    regex = 'GDPR-22'
    #regex = "RISK-1"
    request "nodes/create-regex/#{regex}", (data)->
      #console.log data
      #console.log data.nodes_created
      data.matches.assert_Is_Bigger_Than 7
      data.nodes_created.assert_Is_Bigger_Than 7 #20