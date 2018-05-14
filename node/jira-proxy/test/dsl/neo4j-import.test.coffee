Neo4J_Import  = require '../../src/dsl/neo4j-import'
Neo4J_Issues  = require '../../src/neo4j/neo4j-issues'
Neo4J         = require '../../src/neo4j/neo4j'
Jira          = require '../../src/dsl/jira'


describe 'dsl | dsl-use-cases', ->

  before ->
    @.neo4j_Import = new Neo4J_Import()
    @.neo4j_Issues = new Neo4J_Issues()
    @.neo4j        = new Neo4J()
    @.jira         = new Jira()


  @.timeout 5000

  it.only 'test', ->
    console.log 'here'

  it 'by_Brands_not_Fixed_Risks',->
    result = await @.neo4j_Import.clear()
                  .by_Brands_not_Fixed_Risks()
    result.size().assert_Is_Bigger_Than 20

  it 'not_Fixed_Risks',->
    result = await @.neo4j_Import.clear()
                    .not_Fixed_Risks('risk_Owners')
    result.size().assert_Is_Bigger_Than 20

  it 'all_Issues_by_Filter (RISK:status)',->
    result = await @.neo4j_Import.clear()
                    .all_Issues_by_Filter('RISK','Risk Rating', 'status')
    result.size().assert_Is_Bigger_Than 20

  it 'all_Issues_by_Filter (Vulnerability:Risk Rating,status)',->
    result = await @.neo4j_Import.clear()
                    .all_Issues_by_Filter('Vulnerability','Risk Rating', 'status')
    result.size().assert_Is_Bigger_Than 20

  it 'all_Issues_by_Filter (Project:Risk Rating,status)',->
    result = await @.neo4j_Import.clear()
                    .all_Issues_by_Filter('Project','Risk Rating', 'status')
    result.size().assert_Is_Bigger_Than 20

  it 'all_Issues_by_Filter (Project:Risk Rating,status)',->
    result = await @.neo4j_Import.clear()
                    .all_Issues_by_Filter('Project','Risk Rating', 'cost_Centers')
    result.size().assert_Is_Bigger_Than 20

  it 'all_Risks_by_Filter (test)',->
    items = @.neo4j_Import.jira['status']()
    console.log items['Awaiting Acceptance'].size()

    for issue in items['Awaiting Acceptance']
      console.log issue['Issue Type']
    console.log 'done'



  it 'map epic-programme-projects',->  # todo: move to neo4j-import dsl code
    issue_Linked_Issues = (key, issue_Type)=>
      matches = []
      issue = @.jira.issues()[key]
      if issue
        for item in issue['Linked Issues']
          key = item.key
          linked_Issue = @.jira.issues()[key]
          if linked_Issue and linked_Issue['Issue Type'] is issue_Type
            matches.push key
      return matches

    issues_Linked_Issues = (keys, issue_Type)=>
      child_Issues = []
      for key in keys
        linked_Issues = issue_Linked_Issues(key,issue_Type)
        child_Issues  = child_Issues.concat(linked_Issues).unique()
      return child_Issues


    await @.neo4j_Import.clear()
    fy19_Epic = 'SEC-5510'
    programmes_Ids = issue_Linked_Issues(fy19_Epic, 'Programme')
    projects_Ids   = issues_Linked_Issues(programmes_Ids, 'Project')

    await @.neo4j_Issues.add_Issues projects_Ids
    await @.neo4j_Issues.add_Issue  fy19_Epic

    result = await  @.neo4j_Issues.add_Issues_As_Nodes programmes_Ids

    programmes_Ids.size().assert_Is 18
    projects_Ids  .size().assert_Is 130
    result        .size().assert_Is 203


  it 'map epic-programme-projects-risks',->
    issue_Linked_Issues = (key, issue_Type)=>
      matches = []
      issue = @.jira.issues()[key]
      if issue
        for item in issue['Linked Issues']
          key = item.key
          linked_Issue = @.jira.issues()[key]
          if linked_Issue and linked_Issue['Issue Type'] is issue_Type
            matches.push key
      return matches

    issues_Linked_Issues = (keys, issue_Type)=>
      child_Issues = []
      for key in keys
        linked_Issues = issue_Linked_Issues(key,issue_Type)
        child_Issues  = child_Issues.concat(linked_Issues).unique()
      return child_Issues


    await @.neo4j_Import.clear()
    fy19_Epic = 'SEC-5510'
    programmes_Ids = issue_Linked_Issues(fy19_Epic, 'Programme')
    projects_Ids   = issues_Linked_Issues(programmes_Ids, 'Project')

    await @.neo4j_Issues.add_Issues projects_Ids
    await @.neo4j_Issues.add_Issue  fy19_Epic

    result_1 = await  @.neo4j_Issues.add_Issues_As_Nodes programmes_Ids
    result_2 = await  @.neo4j_Issues.add_Issues_As_Nodes projects_Ids

    programmes_Ids.size().assert_Is 18
    projects_Ids  .size().assert_Is 130
    result_1      .size().assert_Is 203
    result_2      .size().assert_Is 858



  it.only 'map_Risks - all_Issues_by_Filter (Vulnerability:Risk Rating,key) - import nodes',->
    @.timeout 20000
    result = await @.neo4j_Import.clear()
                    .all_Issues_by_Filter('RISK','Risk Rating', 'cost_Centers')

    #nodes_Ids = await @.neo4j.nodes_Keys()
    #result = await @.neo4j_Issues.add_Issues nodes_Ids
    #console.log result.size()
    #result.size().assert_Is_Bigger_Than 20