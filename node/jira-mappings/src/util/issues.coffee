Data      = require './Data'

_issue_Files   = null  # local cache
_fields_Schema = null  # local cache

class Issues
  constructor: ->
    @.data = new Data()

  fields_Schema: ()->
    _fields_Schema = null
    if not _fields_Schema
      raw_Data = @.data.file_Fields_Schema.load_Json()
      _fields_Schema = @.map_Fields_Schema(raw_Data)
    _fields_Schema

  map_Fields_Schema: (raw_Data)->
    results = {} #by_Name: {}, by_Id: {}
    for item in raw_Data
      if results[item.id]
        console.log 'error on ' + results[item.id]
      results[item.id] =
        name : item.name
        schema_Type_Name: item.schema?.type
        schema_Type_Class: item.schema?.custom
        schema_Type_ID   : item.schema?.id
      #console.log item

    return results

  issue_File: (id)->
    path = @.issue_Files()[id]
    if path
      return @.data.folder_Issues_Raw.path_Combine(path)
    return null

  issue_Files: ->
    if not _issue_Files
      _issue_Files = @.data.file_Issue_Files.load_Json()
    return _issue_Files

  issue_Raw_Data: (id)=>
    id = id?.upper()               # all ids in Jira are upper case
    path = @.issue_File(id)
    if path
        return path.load_Json()
    return null




module.exports = Issues