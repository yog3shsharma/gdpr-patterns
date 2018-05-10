express         = require 'express'
Data            = require '../../../jira-issues/src/data'
Config          = require '../../../jira-issues/src/config'
Map_Issues      = require '../../../jira-mappings/src/map-issues'
Save_Data       = require '../../../jira-issues/src/jira/save-data'

class Jira
  constructor: (options)->
    @.options         = options || {}
    @.router          = express.Router()
    @.app             = @.options.app
    @.log_Requests    = false
    @.data            = new Data()
    @.map_Issues      = new Map_Issues()
    @.save_Data       = new Save_Data()
    #@.config        =  Config
    #@.config        = Config


  add_Routes: ()=>
    @.router.get  '/jira/fields/schema'   , @.fields_Schema
    @.router.get  '/jira/issue-raw/:id'   , @.issue_Raw
    @.router.get  '/jira/issue-delete/:id', @.issue_Delete
    @.router.get  '/jira/issue/:id'       , @.issue
    @.router.get  '/jira/issues/files'    , @.issues_Files
    @.router.get  '/jira/issues/ids'      , @.issues_Ids
    @.router.get  '/jira/issues/convert'  , @.issues_Convert
    @

  send_Json_Data:(req,res,json_Data)->                    # this should be added as a global filter
    pretty = req.query?._keys().contains 'pretty'
    if pretty
      data = json_Data || { error: 'no data'}
      res.send "<pre>#{data.json_Pretty()}</pre>"
    else
      res.json json_Data

  fields_Schema: (req, res)=>
    @.send_Json_Data req, res, @.data.file_Fields_Schema.load_Json()

  issue_Delete: (req,res)=>
    id     = req.params?.id?.to_Safe_String()
    result = @.data.delete_Raw_Data id
    res.send status: result

  issue_Raw: (req,res)=>
    id = req.params?.id?.to_Safe_String()

    @.save_Data.get_Issue id, (result)=>
      @.send_Json_Data req, res, result

  issue: (req,res)=>
    id     = req.params?.id?.to_Safe_String()
    @.save_Data.get_Issue id, (raw_Data)=>                        # will force load if issue doesn't exist locally
      if (raw_Data?.key)                                          # to handle issue rename
        @.send_Json_Data req, res, @.map_Issues.issue(raw_Data.key)
      else
        @.send_Json_Data req, res, raw_Data

  issues_Ids: (req, res)=>
    res.json @.data.issue_Files()._keys()

  issues_Files: (req,res)=>
    res.json @.data.issue_Files()


  issues_Convert: (req, res)=>        # to move to separate file
    files = @.data.file_Issue_Files.load_Json()
    result = files_processed: []
    for key,file of files
      result.files_processed.push key
      data        = @.map_Issues.issue(key)
      target_File = @.data.folder_Issues.path_Combine("#{key}.json")
    res.json result


module.exports = Jira