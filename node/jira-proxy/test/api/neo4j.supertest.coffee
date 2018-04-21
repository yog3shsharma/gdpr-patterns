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

  it 'nodes_Create', ->
    id = 'GDPR-223,GDPR-225,GDPR-226,GDPR-326'
    request "nodes/create/#{id}", (data)->
      console.log data.nodes_created
      data.nodes_created.assert_Is_Bigger_Than 7 #20


  xit 'create-regex', ->
    id = 'GDPR-22'
    request "nodes/create-regex/#{id}", (data)->
      #console.log data
      #console.log data.nodes_created
      data.nodes_created.assert_Is_Bigger_Than 7 #20