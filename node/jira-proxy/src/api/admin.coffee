express   = require 'express'

class Admin
  constructor: (options)->
    @.options       = options || {}
    @.router        = express.Router()
    @.app           = @.options.app
    #@.envs           = new envs()
    @.log_Requests  = false


  add_Routes: ()=>
    if @.app and @.log_Requests
      @.app.get '/*',  (req, res,next)->
        console.log req.url
        next()

    @.router.get  '/admin/ping'       , @.ping
    @.router.get  '/admin/env'       , @.getEnv
    @.router.put  '/admin/env'       , @.putEnv
    @.router.post  '/admin/env'       , @.putEnv
    @

  ping: (req,res)->
    res.send ('pong')
    
  getEnv: (req,res)->
    environment_vars = {
      Jira_Protocol: process.env.Jira_Protocol,
      Jira_Host: process.env.Jira_Host,
      Jira_Username: process.env.Jira_Username,
      Jira_Password: process.env.Jira_Password.length
    }
    res.send environment_vars

  putEnv: (req,res)->
    process.env.Jira_Protocol = req.query.Jira_Protocol
    process.env.Jira_Host = req.query.Jira_Host
    process.env.Jira_Username = req.query.Jira_Username
    process.env.Jira_Password = req.query.Jira_Password
    #console.log(req.query)
    res.send {}


module.exports = Admin