Jira = require '../../src/dsl/jira'

describe 'dsl | exec-code',->

  jira = null

  before ->
    jira = new Jira()

  it '_issues_by_Properties', ->
    jira._issues_by_Properties()
        ._keys().assert_Size_Is_Greater_Than 100
        .assert_Contains ["Pillars","Risk Owner"]

  it 'assignees'       ,-> jira.assignees()      ._keys().size().assert_Is_Bigger_Than 50
  it 'business_Owners' ,-> jira.business_Owners()._keys().size().assert_Is_Bigger_Than 15
  it 'capabilities'    ,-> jira.capabilities()   ._keys().size().assert_Is_Bigger_Than 15
  it 'departments'     ,-> jira.capabilities()   ._keys().size().assert_Is_Bigger_Than 15
  it 'issue_Types'     ,-> jira.issue_Types()    ._keys().size().assert_Is_Bigger_Than 15
  it 'pillars'         ,-> jira.pillars()        ._keys().assert_Is [ 'Trust', 'Prevent', 'Enable', 'Detect', 'Educate' ]
  it 'priority'        ,-> jira.priorities()     ._keys().assert_Is [ 'Minor', 'High', 'Medium', 'Low' ]
  it 'programmes'      ,-> jira.programmes()     ._keys().size().assert_Is_Bigger_Than 15
  it 'risk_Owners'     ,-> jira.risk_Owners()    ._keys().size().assert_Is_Bigger_Than 50
  it 'risk_Ratings'    ,-> jira.risk_Ratings()   ._keys().assert_Is [ 'High', 'To be determined', 'Critical', 'Info', 'Medium', 'Low' ]
  it 'status'          ,-> jira.status()         ._keys().size().assert_Is_Bigger_Than 30





