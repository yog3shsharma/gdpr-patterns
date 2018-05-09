Jira_Api = require '../../src/jira/api'

describe 'Jira_Api', ->
  jira_Api = null

  before ->
    jira_Api = new Jira_Api()

  it 'constructor', ->
    using jira_Api, ->
      @._jira_Api.protocol.assert_Is 'https'


  it 'currentUser', ()->
    jira_Api.currentUser (name)->
      name.assert_Is 'jira.api'

  it 'issue', ()->
    jira_Api.issue 'RISK-1', (issue)->
      issue.fields.summary.assert_Is 'JIRA - Too many JIRA Administrators'

  it 'ping_Server', (done)->
    jira_Api.ping_Server (html)->
      html.assert_Contains 'com.atlassian.jira'
      done()

  it 'search', ()->
    jira_Api.search "project=RISK", (data)->
      data.total.assert_Is_Bigger_Than 398
      data.issues.size().assert_Is 50

  # other
  xit 'should get issues after a certain date', ()->
    fields = ["*all"]
    jira_Api.issues "project=GDPR and id=GDPR-180", fields, (data)->
      #console.log data
      #console.log data.json_Pretty().save_As('test.json')
      #console.log Math.floor(new Date() / 1000)
      #console.log Date.now();