Server  = require '../../src/Server'
request = require 'supertest'

class Supertest

  constructor: ->
    @.server = new Server().setup_Server().add_Routes_Api()
    @.app    = @.server.app

  request: (url, callback)->
    request(@.app)
      .get url
      .expect (res)->
        if res.headers['content-type'] is 'application/json; charset=utf-8'
          callback res.text.json_Parse()
        else
          callback res.text

module.exports = Supertest