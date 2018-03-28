Data      = require '../../src/data'
Map_Files = require '../../src/mappings/map-files'

describe 'X-Refs | Create', ->
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
      data.folder_Issues.path_Combine(@[key]).assert_File_Exists()
