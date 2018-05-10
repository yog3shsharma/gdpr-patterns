Track_Queries = require '../../src/jira/track-queries'

describe 'Track-Queries', ->
  track_Queries = null

  before ->
    track_Queries = new Track_Queries()

  it 'constructor', ->
    using track_Queries ,->
      @.data.file_Tracked_Queries.assert_File_Exists()

  it 'create', ->
    name = 'test-name'
    jql  = 'test-jql'
    track_Queries.create name,jql
    using track_Queries.current() ,->
      @[name].assert_Is { jql:jql, issues_saved:0 , last_updated:null }

  it 'current', ->
    using track_Queries.current() ,->
      @.assert_Is_Object()

  it 'delete',->
    name = 'test-name'
    track_Queries.delete name
    using track_Queries.current() ,->
      assert_Is_Undefined @[name]


  it 'now_Date',->
    using track_Queries.now_Date(), ->
      @.assert_Contains(new Date().getFullYear())

  xit 'update', (done)->
    #@.timeout 15000
    name = 'gdpr-project'
    jql  = 'project=GDPR'
    using track_Queries, ->
      @.create name, jql
      @.update name , (result)->
        console.log result.size()
        console.log track_Queries.current()[name]

        done()

