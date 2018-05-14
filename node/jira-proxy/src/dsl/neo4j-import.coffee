Neo4J         = require '../neo4j/neo4j'
Jira          = require '../dsl/jira'
Neo4J_Issues  = require '../../src/neo4j/neo4j-issues'

class Neo4J_Import
  constructor: ->
    @.jira = new Jira()
    @.neo4j = new Neo4J()

  clear : ()=>
    @.neo4j.delete_all_nodes()
    @


  by_Brands_not_Fixed_Risks: ->
    result = []
    brands = @.jira.brands()
    for name, issues of brands
      #await @.neo4j.add_Node "Risk_Owner", name
      for issue in issues
        if issue['Issue Type'] is 'RISK' and issue['Status'] isnt 'Fixed' and issue['Status'] isnt 'Closed'
          target_label = issue['Risk Rating']
          target_key   = issue.key
          result.add await @.neo4j.add_Edge "Risk_Owner", name, "owns risk", target_label, target_key
    return result

  by_Brands_Fixed_Risks: ->
    result = []
    brands = @.jira.brands()
    for name, issues of brands
      for issue in issues
        if issue['Issue Type'] is 'RISK' and issue['Status'] is 'Fixed'
          target_label = issue['Risk Rating']
          target_key   = issue.key
          result.add await @.neo4j.add_Edge "Risk_Owner", name, "owns risk", target_label, target_key
    return result

  not_Fixed_Risks: (filter)->
    result = []
    items = @.jira[filter]()
    for name, issues of items
      for issue in issues
        if issue['Issue Type'] is 'RISK' and issue['Status'] isnt 'Fixed' and issue['Status'] isnt 'Closed'
          target_label = issue['Risk Rating']
          target_key   = issue.key
          result.add await @.neo4j.add_Edge "Risk_Owner", name, "owns risk", target_label, target_key
    return result

  all_Issues_by_Filter: (issue_Type, target_Label, filter)->
    result = []
    items = @.jira[filter]()
    for name, issues of items
      for issue in issues
        if issue?['Issue Type'] is issue_Type
          target_label = issue[target_Label]
          target_key   = issue.key
          result.add await @.neo4j.add_Edge filter, name, issue_Type, target_label, target_key
    return result


module.exports = Neo4J_Import