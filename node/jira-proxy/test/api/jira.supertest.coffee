Supertest = require '../../src/_test-utils/Supertest'

describe 'api | supertest | Jira', ->
  supertest = null

  request = (path, callback)->
    supertest.request "/api/jira/#{path}", callback

  before ->
    supertest = new Supertest()

  it 'fields/schema', ->
    request 'fields/schema', (data)->
      data.size().assert_In_Between 300,500
      data[0].id.assert_Is 'resolution'

  it 'fields/schema?pretty', ->
    request 'fields/schema?pretty', (data)->

      data.assert_Contains("<pre>")
          .assert_Contains('"id": "resolution"')

  it 'jira/issue-raw/RISK-1', ->
    supertest.request '/api/jira/issue-raw/RISK-1', (data)->
      data.assert_Is_Object()
      data.key.assert_Is 'RISK-1'

  it 'jira/issue-raw/RISK-1?pretty', ->
    supertest.request '/api/jira/issue-raw/RISK-1?pretty', (data)->
      data.assert_Is_String()
      data.assert_Contains '"key": "RISK-1"'

  it 'jira/issue/RISK-1', ->
    supertest.request '/api/jira/issue/RISK-1', (data)->
      data.assert_Is_Object()
      data.id.assert_Is 'risk-1'

  it 'jira/issue/RISK-1', ->
    supertest.request '/api/jira/issue/RISK-1?pretty', (data)->
      data.assert_Is_String()
      data.assert_Contains '"id": "risk-1"'

  it 'jira/issues/ids', ->
    supertest.request '/api/jira/issues/ids', (data)->
      data.assert_Contains ['RISK-1']

  it 'jira/issues/files', ->
    supertest.request '/api/jira/issues/files', (data)->
      data["RISK-1"].assert_Is '/RISK/RISK/RISK-1.json'


  xit 'jira/issues_Convert', ->
    supertest.request '/api/jira/issues/convert', (data)->
      console.log data
