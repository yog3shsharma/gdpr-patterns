Supertest = require '../../src/_test-utils/Supertest'

describe 'api | supertest | files', ->
  supertest = null

  request = (path, callback)->
    supertest.request "/api/js/#{path}", callback

  before ->
    supertest = new Supertest()

  it 'neovis.js', ->
    request 'neovis.js', (data)->
      data.assert_Contains '(function webpackUniversalModuleDefinition'

