Data = require '../../src/util/data'

describe 'Data', ->
  data = null
  before ->
    data = new Data();

  it 'constructor',->
    data.folder_Data.path_Combine('../hugo').assert_Folder_Exists()