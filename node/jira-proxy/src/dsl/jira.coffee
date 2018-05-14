Data            = require '../../../jira-issues/src/data'
_issues_by_Keys       = null
_issues_by_Properties = null        # local cache to speed up look ups
                                    # todo: move all these cached files into separate class

class Jira
  constructor: ->
    @.data = new Data()

  _issues_by_Keys: ->
    if not _issues_by_Keys
      _issues_by_Keys = @.data.issues_by_Keys()
    return _issues_by_Keys

  _issues_by_Properties: ->
    if not _issues_by_Properties
      _issues_by_Properties = @.data.issues_by_Properties()
    return _issues_by_Properties

  _expand_Issues: (data)->
    result = {}
    issues = @._issues_by_Keys()

    for name,value of data
      result[name]=[]
      for key in value
        result[name].add issues[key]
        @._add_Helper_Methods(result[name])
    return result

  _add_Helper_Methods: (target)->
    target.keys      = -> (item.key     for item in @)
    target.summaries = -> (item.Summary for item in @)

  issues           : => @._issues_by_Keys()

  assignees        : => @._expand_Issues @._issues_by_Properties()["Assignee"           ]
  brands           : => @._expand_Issues @._issues_by_Properties()["Brands"             ]
  business_Owners  : => @._expand_Issues @._issues_by_Properties()["Business Owner"     ]
  cost_Centers     : => @._expand_Issues @._issues_by_Properties()["Cost Center"        ]
  capabilities     : => @._expand_Issues @._issues_by_Properties()["Security Capability"]
  departments      : => @._expand_Issues @._issues_by_Properties()["Department"         ]
  issue_Types      : => @._expand_Issues @._issues_by_Properties()["Issue Type"         ]
  priorities       : => @._expand_Issues @._issues_by_Properties()["Priority"           ]
  risk_Owners      : => @._expand_Issues @._issues_by_Properties()["Risk Owner"         ]
  risk_Ratings     : => @._expand_Issues @._issues_by_Properties()["Risk Rating"        ]
  pillars          : => @._expand_Issues @._issues_by_Properties()["Security Pillar"    ]
  _programmes      : => @._expand_Issues @._issues_by_Properties()["Security Programme" ]  # temp
  status           : => @._expand_Issues @._issues_by_Properties()["Status"             ]

  data_Journeys     : => @.issue_Types()['Data Journey'      ]
  data_Sources      : => @.issue_Types()['Data Source'       ]
  epics             : => @.issue_Types()['Epic'              ]
  incidents         : => @.issue_Types()['Incident'          ]
  #pillars           : => @.issue_Types()['Pillar'           ]   # mappings are today better done as a property (see above)
  programmes        : => @.issue_Types()['Programme'         ]
  projects          : => @.issue_Types()['Project'           ]
  risks             : => @.issue_Types()['RISK'              ]
  systems           : => @.issue_Types()['IT System'         ]
  tasks             : => @.issue_Types()['Task'              ]
  controls          : => @.issue_Types()['Security Controls' ]
  gGoals            : => @.issue_Types()['Security Goal'     ]
  vulns             : => @.issue_Types()['Vulnerability'     ]

module.exports = Jira
