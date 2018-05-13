express   = require 'express'

class Debug
  constructor: (options)->
    @.options       = options || {}
    @.router        = express.Router()
    @.app           = @.options.app
    @.log_Requests  = false


  add_Routes: ()=>
    # use this to see all requests
    if @.app and @.log_Requests
      @.app.get '/*',  (req, res,next)->
        console.log req.url
        next()

    @.router.get  '/debug/ping'       , @.ping
    @.router.get  '/git/pull'         , @.git_pull
    @.router.get  '/jira/status'      , @.jira_status
    @

  ping: (req,res)->
    res.send ('pong')

  git_pull: (req,res)->     #todo: add unit test
    cmd    = 'git'
    params = ['pull']
    cmd.start_Process_Capture_Console_Out params, (data)->
      result =
        cmd     : cmd
        params  : params
        cmd_log : data;
      res.json(result)

  jira_status: (req,res)->  #todo: wire with code that checks if jira is online (and ideally with code that checks if we can login ok)

module.exports = Debug