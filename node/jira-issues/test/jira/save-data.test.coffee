Save_Data = require '../../src/jira/save-data'

describe 'Save-Data', ->
  save_Data = null

  before ->
    save_Data = new Save_Data()

  it 'constructor', ->
    using save_Data, ->
      @.jira._jira_Api.apiVersion.assert_Is 'latest'
      @.data.folder_Data         .assert_Folder_Exists()
      @.data.folder_Issues_Raw   .assert_Folder_Exists()

  it 'save_Issue', ->
    save_Data.save_Issue 'RISK-1', (file)->
      file.parent_Folder()                .folder_Name().assert_Is 'RISK'   # check that parent folder is the issue type
      file.parent_Folder().parent_Folder().folder_Name().assert_Is 'RISK'   # check that parent's parent folder is the project type
      file.assert_File_Exists()
      using file.load_Json(),->
        @.key.assert_Is 'RISK-1'
        @.summary.assert_Is 'JIRA - Too many JIRA Administrators'

  it.only 'save_Issues_Schema', ->
    save_Data.save_Issues_Schema()



  xit 'save_Issues', ->
    jql = "issue in linkedIssues(Risk-218) and issuetype = 'Risk'"
    save_Data.save_Issues jql, (data)->
      data[0].assert_File_Exists



xdescribe 'Data-Analysis | Check Data collected', ->
  save_Data = null

  before ->
    save_Data = new Save_Data()

  it 'check that linked issues are saved', ->
    save_Data.save_Issue 'Risk-218', (file, data)->
      using file.load_Json(), ->
        @.issuelinks.assert_Size_Is_Bigger_Than 10
        @.issuelinks[0].outwardIssue.key.assert_Is 'RISK-244'
