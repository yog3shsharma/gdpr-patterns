Data = require '../../src/util/data'

describe 'Data', ->
  data = null
  before ->
    data = new Data();

  it 'constructor',->
    using new Data(),->
      @.folder_Data
      @.folder_Data      .assert_Folder_Exists()
      @.folder_Issues_Raw.assert_Folder_Exists()
      @.folder_Mappings  .assert_Folder_Exists()