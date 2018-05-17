require 'fluentnode'

JiraApi = require('jira-client')
Config  = require('../../src/config')


class Api
  constructor: ->
    @._jira_Api = new JiraApi(Config)

  currentUser: (callback)->
    @._call_Jira 'getCurrentUser', [], (data)->
      callback data.name

  _call_Jira: (command, params, callback)=>
    if (await @.jira_Server_Available())
      console.log("Request made")
      @._jira_Api[command].apply(@._jira_Api,  params)
        .then (data)->
          console.log("Request completed")
          callback data
        .catch (err)->
          console.log err.message
          callback {"jira_error" : err.message }
    else
      console.log {"jira_error" : 'jira server offline' }
      callback null



  issue: (key, callback)->
    issueNumber  = key.upper()
    expand       = ""
    fields       = ""
    properties   = "*"
    fieldsByKeys = false
    @._call_Jira "findIssue", [issueNumber,expand, fields,properties,fieldsByKeys], callback

  issues: (jql, fields, callback)=>
    callback = callback || fields           # make fields value optional
    issues   = []
    options =
      startAt   : 0
      maxResults: 500
      #expand    : ['changelog']
      fields    : fields || ['summary','status']

    get_Issues = () =>
      @._call_Jira "searchJira", [jql,options], (data)->
        if data?.issues?.size() > 0
          #console.log options, data?.issues?.size()
          #console.log "[jira api] fetched #{data?.issues?.size()} issues"
          options.startAt += data.issues.size()
          issues = issues.concat data.issues

          callback issues
          issues = []
          get_Issues()                          # recursive call to get more issues

        else
          callback issues                       # no more issues'


    get_Issues jql


  # This can be improved to fail faster when access is not available
  ping_Server: (callback)->
    url = "#{Config.protocol}://#{Config.host}"
    url.GET (data)->
      callback data

  search: (jql, callback)->
    options =
      startAt   : 1
      maxResults: 50
      fields    : ['summary','status']
    @._call_Jira "searchJira", [jql,options], callback


  jira_Server_Available: ()=>
    port = if (Config.protocol is 'https') then 443 else 80
    host = Config.host
    @.server_Available host, port

  server_Available: (host,  port)=>
    net     = require 'net'
    options =
      timeout : 100
      host    : host
      port    : port

    return new Promise (resolve) =>
      using new net.Socket(), ->
        @.setTimeout(options.timeout);
        @.on 'error'                        , () => @.destroy(); resolve(false);
        @.on 'timeout'                      , () => @.destroy(); resolve(false);
        @.connect options.port, options.host, () => @.end()    ; resolve(true);



module.exports = Api