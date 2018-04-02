Jira = require '../../src/api/jira'

describe 'api | jira', ->
  jira = null
  req   = null
  res   = null

  beforeEach ->
    jira =  new Jira()
    req = {}
    res =
      send: ->
      json: ->

  afterEach ->
    #if expected_Res

  it 'constructor', ->
    using jira, ->
      @.constructor.name.assert_Is 'Jira'
      @.router.assert_Is_Function()

  it 'config', ->
    res.json = (data)->
        data.via_config.assert_Is_True()
    jira.config(req,res)

  it 'isues_Raw', ->
    res.json (data)->
      console.log data

    req = params : id : 'RISK-1'
    jira.issues_Raw(req,res)

