express    = require 'express'
Jira_Api   = require '../../../jira-issues/src/jira/api'
Config     = require('../../../jira-issues/src/config')

class Jira
  constructor: (options)->
    @.options       = options || {}
    @.router        = express.Router()
    @.app           = @.options.app
    @.jira_Api      = new Jira_Api()


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
    @.jira_Api.issue id,  (data)->
      res.json data


module.exports = Jira