Supertest = require '../../src/_test-utils/Supertest'

describe 'api | supertest | neo4j', ->
  supertest = null

  request = (path, callback)->
    supertest.request "/api/neo4j/#{path}", callback

  before ->
    supertest = new Supertest()

  it 'cypher', ->
    request 'cypher', (data)->
      console.log data

  xit 'create', ->
    request 'create/AAAA?aaa=123&bbb=678', (data)->
      console.log data

  xit 'create/all-nodes ', ->
    request 'create-all-nodes', (data)->
      console.log data

