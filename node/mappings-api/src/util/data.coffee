require 'fluentnode'

class Data
  constructor: ->
    @.folder_Data        =  (wallaby?.localProjectDir.path_Combine('../..') || './').path_Combine('data')
    @.folder_Issues_Raw  = @.folder_Data.path_Combine('Issues_Raw')
    @.folder_Mappings    = @.folder_Data.path_Combine('Mappings')
    @.file_Issue_Files   = @.folder_Mappings.path_Combine 'issue-files.json'

  setup: ->
    # make sure folders exist
    @.folder_Data    .folder_Create()
    @.folder_Issues  .folder_Create()
    @.folder_Mappings.folder_Create()

module.exports = Data



