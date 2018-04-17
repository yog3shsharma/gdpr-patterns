Supertest = require '../../src/_test-utils/Supertest'

describe '_testUtils | Supertest', ->
  supertest = null

  before ->
    supertest = new Supertest()


  it 'constructor',->
    using supertest, ->
      @.server.constructor.name.assert_Is 'Server'

  it 'request', ->
    supertest.request '/api/debug/ping', (data)->
      data.assert_Is 'pong'