express   = require 'express'
Data      = require '../../../jira-issues/src/data'
Config    = require '../../../jira-issues/src/config'
class Jira
  constructor: (options)->
    @.options       = options || {}
    @.router        = express.Router()
    @.app           = @.options.app
    @.log_Requests  = false
    @.data          = new Data()
    #@.config        =  Config
    #@.config        = Config


  add_Routes: ()=>
    @.router.get  '/jira/config'           , @.config
    @.router.get  '/jira/issues-raw/:id'   , @.issues_Raw
    @

  config: (req,res)=>
    res.json Config

  issues_Raw: (req,res)=>
    id = req.params?.id?.to_Safe_String()
    #res.json @.data.issue_Raw_Data id
    res.send @.data.issue_Raw_Data(id)?.json_Pretty()


module.exports = Jira