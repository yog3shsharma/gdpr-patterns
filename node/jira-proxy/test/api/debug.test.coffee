Debug = require '../../src/api/debug'

describe 'api | debug', ->
  debug = null
  req   = null
  res   = null

  beforeEach ->
    debug =  new Debug()
    req = {}
    res =
      send: ->
      json: ->

  afterEach ->
    #if expected_Res

  it 'constructor', ->
    using debug, ->
      @.constructor.name.assert_Is 'Debug'
      @.router.assert_Is_Function()

  it 'ping', ->
    res.send = (data)->
        data.assert_Is 'pong'
    debug.ping(req,res)
