Data = require '../../src/util/data'

describe 'Data', ->
  data = null
  before ->
    data = new Data();

  it 'constructor',->
    data.folder_Data.path_Combine('../hugo').assert_Folder_Exists()

  it 'setup',->
    using data.setup(), ->
      @.folder_Data       .assert_Folder_Exists()     # check folders
      @.folder_Issues_Raw .assert_Folder_Exists()
      @.folder_Mappings   .assert_Folder_Exists()

      @.file_Issue_Files  .assert_File_Exists()       # check files
      @.file_Fields_Schema.assert_File_Exists()
