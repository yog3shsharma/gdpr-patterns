Data      = require '../../jira-issues/src/data'
Map_Files = require '../src/map-files'

describe 'Map_Files', ->
  data      = null
  map_Files = null

  before ->
    data      = new Data()
    map_Files = new Map_Files(data)

  it 'constructor',->
    map_Files.data.assert_Is data

  it 'create', ->
    file = map_Files.create().assert_File_Exists()

    using file.load_Json(), ->
      key = @._keys().first()
      data.folder_Issues_Raw.path_Combine(@[key]).assert_File_Exists()
