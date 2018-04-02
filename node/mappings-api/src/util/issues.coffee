Data      = require './Data'

_issue_Files = null  # local cache

class Issues
  constructor: ->
    @.data = new Data()

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
    path = @.issue_File(id)
    if path
        return path.load_Json()
    return null


module.exports = Issues