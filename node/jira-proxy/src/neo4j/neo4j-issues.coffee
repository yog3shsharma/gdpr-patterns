Map_Issues = require '../../../jira-mappings/src/map-issues'
Neo4j      = require '../neo4j/neo4j'
async      = require 'async'

class Neo4j_Issues
  constructor:->
    #@.data = new Data()
    @.map_Issues = new Map_Issues()
    @.neo4j = new Neo4j()

  add_Issue: (id, callback)=>
    console.log id
    data  = @.map_Issues.issue(id)
    delete data['Linked Issues']
    label = data['Issue Type']
    @.neo4j.create_node label, data, callback

  add_Issues: (ids, callback, done)=>
    result = []
    add_Helper = (id, next)=>
      @.add_Issue id, (err, data)=>
        added_Id = data.records[0]._fields[0].properties.id
        result.push added_Id
        next()

    async.eachSeries ids, add_Helper, ()->
      callback null, result


module.exports = Neo4j_Issues