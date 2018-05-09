Supertest = require '../../src/_test-utils/Supertest'

describe.only 'api | supertest | jira-server', ->
  supertest = null

  request = (path, callback)->
    supertest.request "/api/jira-server/" + path, callback

  before ->
    supertest = new Supertest()

  it 'config', ->
    request 'config', (data)->
      data.protocol.assert_Is 'https'

  it 'homepage', ->
    request 'homepage', (data)->
      data.assert_Contains 'System Dashboard'

  it 'issue/{id}', ->
    id = 'RISK-2'
    request "issue/#{id}", (data)->
      data.key.assert_Is id


  it 'issue/{id} (id not exists)', ->
    id = 'AAAA-bb'
    request "issue/#{id}", (data)->
      data.jira_error.assert_Contains  'Issue Does Not Exist'

