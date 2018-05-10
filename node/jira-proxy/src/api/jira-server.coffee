express         = require 'express'
Config          = require '../../../jira-issues/src/config'
Data            = require '../../../jira-issues/src/data'
Jira_Api        = require '../../../jira-issues/src/jira/api'
Save_Data       = require '../../../jira-issues/src/jira/save-data'
Mappings_Create = require '../../../jira-mappings/src/create'
Track_Queries   = require '../../../jira-issues/src/jira/track-queries'


class Jira
  constructor: (options)->
    @.options         = options || {}
    @.router          = express.Router()
    @.app             = @.options.app
    @.data            = new Data()
    @.jira_Api        = new Jira_Api()
    @.save_Data       = new Save_Data()
    @.mappings_Create = new Mappings_Create()
    @.track_Queries   = new Track_Queries()


  add_Routes: ()=>
    @.router.get  '/jira-server/setup'                       , @.setup
    @.router.get  '/jira-server/config'                      , @.config
    @.router.get  '/jira-server/homepage'                    , @.homepage
    @.router.get  '/jira-server/issue/:id'                   , @.issue
    @.router.get  '/jira-server/mappings/issues/files'       , @.mappings_Issues_Files
    @.router.get  '/jira-server/mappings/create'             , @.mappings_Create_All
    @.router.get  '/jira-server/track-queries/current'       , @.track_Queries_Current
    @.router.get  '/jira-server/track-queries/create/:name'  , @.track_Queries_Create
    @.router.get  '/jira-server/track-queries/delete/:name'  , @.track_Queries_Delete
    @.router.get  '/jira-server/track-queries/update/:name'  , @.track_Queries_Update
    @

  send_Json_Data:(req,res,json_Data)->                    # this should be added as a global filter
    pretty = req.query?._keys().contains 'pretty'
    if pretty
      data = json_Data || { error: 'no data'}
      res.send "<pre>#{data.json_Pretty()}</pre>"
    else
      res.json json_Data

  config: (req,res)=>
    @.send_Json_Data req,res, Config

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

  track_Queries_Current: (req, res)=>
    @.send_Json_Data req,res, @.track_Queries.current()

  track_Queries_Create: (req, res)=>
    name = req.params.name
    jql  = req.query.jql
    if name and jql
      @.track_Queries.create name, jql
      res.json status: 'track query created'
    else
      res.json error: 'name and jql must be provided'

  track_Queries_Delete: (req,res)=>
    name = req.params.name
    if name
      result = @.track_Queries.delete name
      @.send_Json_Data req,res, result
    else
      res.json error: 'name  must be provided'

  track_Queries_Update: (req,res)=>
    name = req.params.name
    if name
      @.track_Queries.update name, (result)=>
        @.send_Json_Data req,res, result
    else
      res.json error: 'name  must be provided'

  setup: (req,res)=>        # todo: refactor into separate class so that it can be called during the server setup

    @.data.setup()                          # setup data folders
    @.mappings_Create.all()                 # create first set of mappings
    await @.save_Data.save_Issues_Schema()  # make sure schema exists

    result =
      folder_Data         : @.data.folder_Data
      folder_Issues       : @.data.folder_Issues
      folder_Issues_Raw   : @.data.folder_Issues_Raw
      folder_Mappings     : @.data.folder_Mappings
      file_Fields_Schema  : @.data.file_Fields_Schema
      issue_Files         : @.data.file_Issue_Files
    @.send_Json_Data req,res, result

module.exports = Jira