Neo4J_Import  = require '../../src/dsl/neo4j-import'
Neo4J_Issues  = require '../../src/neo4j/neo4j-issues'
Neo4J         = require '../../src/neo4j/neo4j'
Jira          = require '../../src/dsl/jira'


describe 'dsl | gdpr-dsl', ->
  before ->
    @.neo4j_Import = new Neo4J_Import()
    @.neo4j_Issues = new Neo4J_Issues()
    @.neo4j        = new Neo4J()
    @.jira         = new Jira()

  it.only 'Data Journeys',->
    @.timeout 50000
    #
    data_Journeys = @.jira.data.issues_by_Properties()['Issue Type']['Data Journey']
    issue         = @.jira.issue(data_Journeys[0])
    linked_Issues = @.jira.issue_Linked_Issues(issue.key)

    await @.neo4j_Import.clear()
    result_1 = await @.neo4j_Issues.add_Issue_And_Linked_Nodes issue.key
    #result_1.size().assert_Is 63
    #result_2 = await @.neo4j_Issues.add_Issues_As_Nodes linked_Issues


    #result_2.size().assert_Is 3524







