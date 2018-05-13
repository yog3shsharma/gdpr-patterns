CoffeeScript = require 'coffeescript'

Data            = require '../../../jira-issues/src/data'
Config          = require '../../../jira-issues/src/config'
Map_Issues      = require '../../../jira-mappings/src/map-issues'
Save_Data       = require '../../../jira-issues/src/jira/save-data'
Neo4J_Api       = require '../neo4j/neo4j'

class Exec_Code
  constructor: ->
    @.data       = new Data()
    @.config     = Config
    @.map_Issues = new Map_Issues()
    @.save_Data  = new Save_Data()
    @.neo4j      = new Neo4J_Api()

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

module.exports = Exec_Code