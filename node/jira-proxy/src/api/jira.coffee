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
    @.router.get  '/jira/config'          , @.config
    @.router.get  '/jira/fields/schema'   , @.fields_Schema
    @.router.get  '/jira/issue-raw/:id'   , @.issue_Raw
    @.router.get  '/jira/issue/:id'       , @.issue
    @.router.get  '/jira/issues/files'    , @.issues_Files
    @.router.get  '/jira/issues/ids'      , @.issues_Ids

    @

  config: (req,res)=>
    res.json Config

  fields_Schema: (req, res)=>
    pretty = req.query?._keys().contains 'pretty'
    if pretty
      json = @.data.file_Fields_Schema.load_Json().json_Pretty()
      res.send "<pre>#{json}</pre>"
    else
      res.json @.data.file_Fields_Schema.load_Json()

  issue_Raw: (req,res)=>
    id = req.params?.id?.to_Safe_String()
    res.json @.data.issue_Raw_Data id
    #res.send @.data.issue_Raw_Data(id)?.json_Pretty()

  issue: (req,res)=>
    id     = req.params?.id?.to_Safe_String()
    pretty = req.query?._keys().contains 'pretty'
    if pretty
      json = @.data.issue_Data(id).json_Pretty()
      res.send "<pre>#{json}</pre>"
    else
      res.json @.data.issue_Data(id)

  issues_Ids: (req, res)=>
    res.json @.data.issue_Files()._keys()

  issues_Files: (req,res)=>
    res.json @.data.issue_Files()


module.exports = Jira