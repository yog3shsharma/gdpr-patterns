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

  it 'issue_Raw', ->
    res.json =  (data)->
      data.key.assert_Is req.params.id

    req = params : id : 'RISK-1'
    jira.issue_Raw(req,res)

  it 'issue', ->
    res.json = (data)->
      console.log data

    req = params : id : 'RISK-1'
    jira.issue(req,res)

  xit 'issues_Ids',->
    res.json = (data)->
      data.assert_Contains 'RISK-1'
      data.assert_Size_Is_Above 10
    jira.issues_Ids(req,res)



