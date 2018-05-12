Supertest = require '../../src/_test-utils/Supertest'

describe 'api | supertest | files', ->
  supertest = null

  before ->
    supertest = new Supertest()

  request = (path, callback)->
    supertest.request "/api/js/#{path}", callback

  it 'neovis.js', ->
    request 'neovis.js', (data)->
      data.assert_Contains '(function webpackUniversalModuleDefinition'

