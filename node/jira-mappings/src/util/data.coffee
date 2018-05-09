require 'fluentnode'

class Data
  constructor: ->
    @.folder_Data        =  (wallaby?.localProjectDir.path_Combine('..') || './').path_Combine('data')
    @.folder_Issues_Raw  = @.folder_Data.path_Combine('Issues_Raw')
    @.folder_Mappings    = @.folder_Data.path_Combine('Mappings')
    @.file_Issue_Files   = @.folder_Mappings.path_Combine 'issue-files.json'
    @.file_Fields_Schema = @.folder_Issues_Raw.path_Combine 'fields-schema.json'

module.exports = Data



