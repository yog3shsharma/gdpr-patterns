Supertest = require '../../src/_test-utils/Supertest'
Jira_API  = require '../../../jira-issues/src/jira/api'

describe 'api | supertest | jira-server', ->
  supertest = null

  before ->
    supertest = new Supertest()
    jira_Api = new Jira_API()
    if not await jira_Api.jira_Server_Available()
      this.skip()

  request = (path, callback)=>
    supertest.request "/api/jira-server/" + path, callback

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
      data.assert_Is { error: "Issue not found: #{id}"}

  it 'issue/{id} (id not exists)', ->
    jql = 'project = RISK and key = RISK-1'
    request "issues?jql=#{jql}", (data)->
      console.log data
      data.issues_retrieved.assert_Is 1
      data.issues_Ids.assert_Is ['RISK-1']


  it 'mappings/issue/files', ->
    request "mappings/issues/files", (result)->
      result["RISK-1"].assert_Is "/RISK/RISK/RISK-1.json"

  it 'setup', ->
    request "setup", (result)->
      using result, ->
        @.folder_Mappings.assert_Folder_Exists()
        @.file_Fields_Schema.assert_File_Exists()
        @.issue_Files.assert_File_Exists()

  it 'mappings/create', ->
    request "mappings/create", (result)->
      result.size().assert_Is 1
      result[0].assert_File_Exists()

  it 'track-queries/current', ->
    request "track-queries/current", (result)->
      result.assert_Is_Object()

  it 'track-queries/create', ->
    id = "projects"
    jql = "project=SEC and issuetype =Project and status = Open"
    request "track-queries/create/#{id}?jql=#{jql}", (result)->
      result.assert_Is status: 'track query created'