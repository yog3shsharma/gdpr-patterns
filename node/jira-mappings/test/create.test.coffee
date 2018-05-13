Create   = require '../src/create'

describe 'Create', ->

  create = null
  before ->
    create = new Create()
  it 'constructor',->
    using create,->
      @.data.folder_Data.assert_Folder_Exists()

  it 'all', ->
    @.timeout 5000
    using create.all() ,->
      @.assert_Is ['issue-files.json','issues-by-key.json','issues-by-properties.json']
      for file in @
        create.data.folder_Mappings.path_Combine file
              .assert_File_Exists()

#  it 'map_Files',->
#    using create.map_Files(), ->
#      @.assert_File_Exists()

  it 'files', ->
    using create.files(),->
      @._keys().size().assert_Is_Bigger_Than 100
      file = create.data.folder_Issues_Raw.path_Combine(@.values().first())
                                          .assert_File_Exists()
      file.load_Json()
          .key.assert_Is file.file_Name_Without_Extension()
