Map_Issues = require '../src/map-issues'

describe 'Jira_Api', ->
  map_Issues = null

  before ->
     map_Issues = new Map_Issues()

  it 'constructor', ->
    using map_Issues, ->
      @.constructor.name.assert_Is 'Map_Issues'
      @.issues.data.folder_Data.assert_Folder_Exists()

  it 'issue', ->
    id = 'RISK-1'
    id = 'RISK-778'
    result = map_Issues.issue(id)

    using map_Issues.issue('GDPR-180'), ->
      @['id'         ].assert_Is 'GDPR-180'
      @['Risk Rating'].assert_Is 'To be determined'
      @['Epic Link'  ].assert_Is 'GDPR-176'

  it 'issue(null)', ->
    assert_Is_Null map_Issues.issue(null)

  it 'get_LinkedIssues' , ()->
    raw_Data =
      [
          { id: '92465', type: { id: '10003', name: 'Relates', inward: 'relates to'     , outward: 'is related to'  } ,outwardIssue: { id: '108223', key: 'SEC-2040' }}
          { id: '92532', type: { id: '10003', name: 'Relates', inward: 'relates to'     , outward: 'is related to'  }, outwardIssue: { id: '108275', key: 'SEC-2060' }}
          { id: '90617', type: { id: '10003', name: 'Risk'   , inward: 'risk reduced by', outward: 'reduces risk of'}, inwardIssue:  { id: '99925' , key: 'SEC-394'  }}
          { id: '90618', type: { id: '10003', name: 'Child'  , inward: 'is parent of'   , outward: 'is child of'    }, inwardIssue:  { id: '107543', key: 'RISK-775' }}
      ]
    result = map_Issues.get_LinkedIssues(raw_Data)
    result.assert_Is  [ { key: 'SEC-2040', type: 'is related to'  , direction: 'outward' },
                        { key: 'SEC-2060', type: 'is related to'  , direction: 'outward' },
                        { key: 'SEC-394' , type: 'risk reduced by', direction: 'outward' },
                        { key: 'RISK-775', type: 'is parent of'   , direction: 'outward' } ]

  it 'get_Data_By_Type' ,->
    raw_Data =
      any:
        raw: 9223372036854775807
        result: 9223372036854775807
      array:
        raw   : [ { self: '.../api/2/customFieldOption/13813', value: 'Article 6(1)(b) - contract', id: '13813' },
                  { self: '.../api/2/customFieldOption/13816', value: 'Article 9(2)(h) - Health',id: '13816' } ]
        result: ['Article 6(1)(b) - contract', 'Article 9(2)(h) - Health']
      comments:
        raw   : { comments:
                  [ {  id: '192644', author: {},  body: '<p>an comment</p>\r\n'     ,created: '2018-01-18T08:29:38.000+0000'},
                    {  id: '192677', author: {},  body: '<p>another comment</p>\r\n',created: '2018-01-18T08:29:38.000+0000'}]}
        result: ['<p>an comment</p>\r\n' , '<p>another comment</p>\r\n']
      'comments-page':
        raw :{}
        result: ''
      datetime:
        raw: '2017-04-04T13:19:48.000+0100'
        result: 'Tue Apr 04 2017'
      issuetype:
        raw: { self: '.../rest/api/2/issuetype/10518', id: '10518', description: '', iconUrl: '...', name: 'RISK', subtask: false, avatarId: 13534 }
        result: 'RISK'
      number:
        raw: 42
        result: 42
      option:
        raw: { self: '..../rest/api/2/customFieldOption/12266', value: 'Low', id: '12266' }
        result: 'Low'
      priority:
        raw : { self: '.../rest/api/2/priority/6', iconUrl: '.../images/icons/priorities/low.svg', name: 'Low', id: '6' }
        result: 'Low'
      progress:
        raw : { progress: 0, total: 0 }
        result: 0
      project:
        raw: { self: '.../rest/api/2/project/12516', id: '12516', key: 'RISK', name: 'RISK'}
        result: 'RISK'
      status:
        raw: { self: '.../rest/api/2/status/3', description: 'Defining what problem we are trying to solve', iconUrl: '.../images/icons/statuses/inprogress.png', name: 'In Progress', id: '3',statusCategory: { self: '.../rest/api/2/statuscategory/4', id: 4, key: 'indeterminate',colorName: 'yellow', name: 'In Progress' } }
        result: 'In Progress'
      string:
        raw: '<p>At the moment...'
        result: '<p>At the moment...'
      timetracking:
        raw: {}
        result: ''
      user:
        raw: { name: 'john.smith',key: 'john.smith', emailAddress: 'john.smith@email.com', displayName: 'John Smith'}
        result: 'john.smith'
      votes:
        raw: { self: '.../rest/api/2/issue/RISK-1/votes', votes: 10, hasVoted: false }
        result: 10
      watches:
        raw: { self: 'https://jira.photobox.com/rest/api/2/issue/RISK-1/watchers', watchCount: 4, isWatching: false }
        result: 4


    for key in raw_Data._keys()
      result = map_Issues.get_Data_By_Type(key, raw_Data[key].raw)

      if result isnt null
        result.assert_Is raw_Data[key].result
      else
        console.log "no parser for: #{key}"

    console.log 'done'



