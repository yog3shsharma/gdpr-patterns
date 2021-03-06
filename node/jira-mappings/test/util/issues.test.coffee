Issues = require '../../src/util/issues'

describe 'Issues', ->
  issues = null

  before ->
    issues = new Issues();

  it 'constructor',->

  it 'fields_Schema', ->
    using issues.fields_Schema(),->
      @.resolution.assert_Is  {
        name             : 'Resolution',
        schema_Type_Name : 'resolution',
        schema_Type_Class: undefined,
        schema_Type_ID   : undefined }


  it 'issue_Files', ->
    using issues.issue_Files(), ->
      @._keys().assert_Contains 'GDPR-180'

  it 'issue_Raw_Data', ->
    key = 'GDPR-180'
    using issues.issue_Raw_Data(key),->
      @.key.assert_Is key

    assert_Is_Null issues.issue_Raw_Data(null)


