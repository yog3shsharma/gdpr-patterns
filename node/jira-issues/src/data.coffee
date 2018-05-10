require 'fluentnode'

class Data
  constructor: ->
    @.folder_Data        =  (wallaby?.localProjectDir || './').path_Combine('data')
    @.folder_Issues      = @.folder_Data.path_Combine('Issues')
    @.folder_Issues_Raw  = @.folder_Data.path_Combine('Issues_Raw')
    @.folder_Mappings    = @.folder_Data.path_Combine('Mappings')

    @.file_Tracked_Queries = @.folder_Data.path_Combine 'tracked_Queries.json'
    @.file_Issue_Files     = @.folder_Mappings.path_Combine 'issue-files.json'
    @.file_Fields_Schema   = @.folder_Issues_Raw.path_Combine 'fields-schema.json'


  setup: ->
    # make sure folders exist
    @.folder_Data       .folder_Create()
    @.folder_Issues     .folder_Create()
    @.folder_Issues_Raw .folder_Create()
    @.folder_Mappings   .folder_Create()
    #{}.save_Json @.file_Tracked_Queries
    @

  delete_Raw_Data: (id)=>
    path = @.issue_Raw_File(id)
    if path?.file_Exists()
      return path.delete_File()
    return true

  issue_Raw_File: (id)->
    path = @.issue_Files()[id?.upper()]
    if path
      return @.folder_Issues_Raw.path_Combine(path)
    return null

  issue_Files: ()->
    if not _issue_Files
      _issue_Files = @.file_Issue_Files.load_Json()
    return _issue_Files

  issue_Files_Reset_cache: ()->
    _issue_Files = null

  issue_Raw_Data: (id)=>
    path = @.issue_Raw_File(id)
    if path
      return path?.load_Json()
    return null

  issue_Data: (id)=>
    path = @.issue_Raw_File(id)
    #return {}
    if path
      return path?.load_Json()
    return null

module.exports = Data



