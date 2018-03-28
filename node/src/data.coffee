require 'fluentnode'

class Data
  constructor: ->
    @.folder_Data     =  (wallaby?.localProjectDir.path_Combine('..') || './').path_Combine('data')
    @.folder_Issues   = @.folder_Data.path_Combine('Issues')
    @.folder_Mappings = @.folder_Data.path_Combine('Mappings')

    @.file_Issue_Files = @.folder_Mappings.path_Combine 'issue-files.json'

    # make sure folders exist
    @.folder_Data    .folder_Create()
    @.folder_Issues  .folder_Create()
    @.folder_Mappings.folder_Create()

  issue_Data: (id)->
    file = @.folder_Issues.path_Combine("#{id}.json")
    if file.file_Exists()
      return file.load_Json()
    return null



module.exports = Data



