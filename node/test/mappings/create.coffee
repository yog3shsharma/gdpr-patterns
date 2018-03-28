Create   = require '../../src/mappings/create'

describe 'X-Refs | Create', ->

  it 'constructor',->
    using new Create(),->
      @.data.folder_Data.assert_Folder_Exists()
