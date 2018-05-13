Data = require '../src/data'

describe 'Data', ->
  data = null
  before ->
    data = new Data();

  it 'constructor',->
    using new Data(),->
      @.folder_Data
      @.folder_Data      .assert_Folder_Exists()
      @.folder_Issues_Raw.assert_Folder_Exists()
      @.folder_Mappings   .assert_Folder_Exists()

  it 'issue_Data', ->
    key = 'GDPR-180'
    using data.issue_Raw_Data(key),->
      @.key.assert_Is key

    assert_Is_Null data.issue_Data(null)

  it 'issues_by_Keys()',->
    using data.issues_by_Keys(),->
      @._keys().size().assert_Is_Bigger_Than 1000

  it 'issues_by_Props()',->
    using data.issues_by_Properties(),->
      @._keys().size().assert_Is_Bigger_Than 100
