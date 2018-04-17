Refactor_Issue   = require '../src/refactor-issue'

describe 'refactor-issue', ->

  refactor_Issue = null

  before ->
    refactor_Issue = new Refactor_Issue()

  it 'constructor',->
    using refactor_Issue,->
      @.data.folder_Data.assert_Folder_Exists()

  it 'map_issue',->
    id = 'GDPR-180'

    using refactor_Issue.map_Issue(id),->
      console.log 'here'