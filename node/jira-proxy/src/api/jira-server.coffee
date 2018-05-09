express         = require 'express'
Jira_Api        = require '../../../jira-issues/src/jira/api'
Save_Data       = require '../../../jira-issues/src/jira/save-data'
Config          = require '../../../jira-issues/src/config'
Mappings_Create = require '../../../jira-mappings/src/create'

class Jira
  constructor: (options)->
    @.options         = options || {}
    @.router          = express.Router()
    @.app             = @.options.app
    @.jira_Api        = new Jira_Api()
    @.save_Data       = new Save_Data()
    @.mappings_Create = new Mappings_Create()


  add_Routes: ()=>
    @.router.get  '/jira-server/config'                , @.config
    @.router.get  '/jira-server/homepage'              , @.homepage
    @.router.get  '/jira-server/issue/:id'             , @.issue
    @.router.get  '/jira-server/mappings/issues/files' , @.mappings_Issues_Files
    @.router.get  '/jira-server/mappings/create'       , @.mappings_Create_All
    @

  send_Json_Data:(req,res,json_Data)->                    # this should be added as a global filter
    pretty = req.query?._keys().contains 'pretty'
    if pretty
      data = json_Data || { error: 'no data'}
      res.send "<pre>#{data.json_Pretty()}</pre>"
    else
      res.json json_Data

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

  mappings_Create_All: (req,res)=>
    res.json @.mappings_Create.all()

  mappings_Issues_Files : (req,res)=>
    @.send_Json_Data req,res, @.mappings_Create.files()

module.exports = Jira