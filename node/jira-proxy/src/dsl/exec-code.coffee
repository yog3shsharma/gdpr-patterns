CoffeeScript = require 'coffeescript'

Data            = require '../../../jira-issues/src/data'
Config          = require '../../../jira-issues/src/config'
Jira            = require '../dsl/jira'
Map_Issues      = require '../../../jira-mappings/src/map-issues'
Save_Data       = require '../../../jira-issues/src/jira/save-data'
Neo4J           = require '../neo4j/neo4j'
Neo4J_Issues    = require '../neo4j/neo4j-issues'

class Exec_Code
  constructor: ->
    @.data          = new Data()
    @.config        = Config
    @.jira          = new Jira()
    @.map_Issues    = new Map_Issues()
    @.save_Data     = new Save_Data()
    @.neo4j         = new Neo4J()
    @.neo4j_Issues  = new Neo4J_Issues()

  coffee: (code)->
    if not code
      return ""
    try
      js = CoffeeScript.compile(code)
    catch err
      #console.log err
      return err
    try
      result = eval(js)
    catch err
      return err
#    if result instanceof Promise
#      result.then (result)->
#        console.log result
#      result.catch (err)->
#        console.log err
    if result then result else ""

  node: (key)->
    return 'getting node ' + key

module.exports = Exec_Code