class Map_File_Paths

  constructor: (@data)->

  create: ->
    xrefs_Files   = {}
    files         = @.data.folder_Issues.files_Recursive()
    issues_Folder =  @.data.folder_Issues.realPath()
    for file in files
      id   = file.file_Name_Without_Extension()
      xrefs_Files[id] = file.remove issues_Folder

    return xrefs_Files.save_Json @.data.file_Issue_Files

module.exports = Map_File_Paths