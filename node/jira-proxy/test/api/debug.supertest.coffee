Server  = require '../../src/Server'
request = require 'supertest'

describe 'api | supertest | Debug', ->
  server  = null                       # these are tests that use supertest, which mean they need to be feed the actual Server object
  app     = null
  version = '/api'

  before ->
    server = new Server().setup_Server().add_Routes_Api()
    app    = server.app

  it '/', ->
    request(app)
      .get '/api/debug/ping'
      .expect (res)->
        res.statusCode.assert_Is 200
        res.text      .assert_Is 'pong'