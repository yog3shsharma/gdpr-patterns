require 'fluentnode'
Supertest = require '../../src/_test-utils/Supertest'

describe 'api | supertest | dsl', ->
  supertest = null

  request = (path, callback)->
    supertest.request "/api/dsl/#{path}", callback

  before ->
    supertest = new Supertest()

  it 'exec - 40+2', ->
    code = "return 40+2".url_Encode()
    request "exec?code=#{code}", (data)->
      data.assert_Is 42

  it 'exec - multiline code', ->
    code = """a = 40
              b = 2
              return a+b"""
    request "exec?code=#{code.url_Encode()}", (data)->
      data.assert_Is 42

  it 'exec - get Risk data', ->
    code = """data        = @.map_Issues.issue('RISK-1')
              data.answer = 42
              return data"""
    request "exec?code=#{code.url_Encode()}", (data)->
      data.key   .assert_Is 'RISK-1'
      data.answer.assert_Is 42

  it 'coffee - run neo4j query', ->
    code = "return @.neo4j.run_Cypher 'MATCH (a) return count(a)'"
    request "exec?code=#{code.url_Encode()}", (data)->
      data.records[0]._fields[0].low.assert_Is_Bigger_Than 1