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

  xit 'create/all-nodes ', ->
    request 'create-all-nodes', (data)->
      console.log data

  xit 'delete/all', ()->
    request 'delete/all', (data)->
      data.records.assert_Is []

