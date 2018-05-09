express    = require 'express'
Jira_Api   = require '../../../jira-issues/src/jira/api'
Save_Data   = require '../../../jira-issues/src/jira/save-data'
Config     = require('../../../jira-issues/src/config')

class Jira
  constructor: (options)->
    @.options       = options || {}
    @.router        = express.Router()
    @.app           = @.options.app
    @.jira_Api      = new Jira_Api()
    @.save_Data     = new Save_Data()


  add_Routes: ()=>
    @.router.get  '/jira-server/config'        , @.config
    @.router.get  '/jira-server/homepage'      , @.homepage
    @.router.get  '/jira-server/issue/:id'     , @.issue
    @

  config: (req,res)=>
    res.json Config

  homepage: (req,res)=>
    @.jira_Api.ping_Server (data)->
      res.send data

  issue: (req,res)=>
    id = req.params.id
    @.save_Data.save_Issue id, (file)->
      if (file?.file_Exists())
        res.json file.load_Json()
      else
        res.json { error: "Issue not found: #{id}"}


module.exports = Jira