require 'fluentnode'

class Data
  constructor: ->
    @.folder_Data     =  (wallaby?.localProjectDir.path_Combine('..') || './').path_Combine('data')
    @.folder_Issues_Raw   = @.folder_Data.path_Combine('Issues_Raw')
    @.folder_Mappings = @.folder_Data.path_Combine('Mappings')

    @.file_Issue_Files = @.folder_Mappings.path_Combine 'issue-files.json'

    # make sure folders exist
    @.folder_Data       .folder_Create()
    @.folder_Issues_Raw .folder_Create()
    @.folder_Mappings   .folder_Create()

  issue_File: (id)->
    path = @.issue_Files()[id]
    if path
      return @.folder_Issues_Raw.path_Combine(path)
    return null

  issue_Files: ->
    if not _issue_Files
      _issue_Files = @.file_Issue_Files.load_Json()
    return _issue_Files

  issue_Raw_Data: (id)=>
    path = @.issue_File(id)
    console.log path.file_Exists()
    if path
      return path.load_Json()
    return null

#  issue_Data: (id)->
#    file = @.folder_Issues_Raw.path_Combine("#{id}.json")
#    if file.file_Exists()
#      return file.load_Json()
#    return null



module.exports = Data



