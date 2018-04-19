Map_Issues = require '../../../jira-mappings/src/map-issues'
Neo4j      = require '../neo4j/neo4j'
async      = require 'async'

class Neo4j_Issues
  constructor:->
    #@.data = new Data()
    @.map_Issues = new Map_Issues()
    @.neo4j = new Neo4j()

  add_Issue: (id, callback)=>
    data  = @.map_Issues.issue(id)
    data['Linked Issues'] = data['Linked Issues'].size()
    #delete data['Linked Issues']
    label = data['Issue Type']
    @.neo4j.create_node label, data, callback

  add_Issues: (ids, callback)=>
    result = []
    add_Helper = (id, next)=>
      @.add_Issue id, (err, data)=>
        if err
          console.log "error adding #{id}"
          console.log err
          callback null, result
        else
          added_Id = data.records[0]._fields[0].properties.id
          result.push added_Id
          next()

    async.eachSeries ids, add_Helper, ()->
      callback null, result


  add_Issue_As_Nodes: (id,callback)->
    data  = @.map_Issues.issue(id)

    type = data['Issue Type']
    key   = data.id
    @.neo4j.create_node type, {key: key}, (err, data)->
      #console.log data
      callback data

  add_Issue_Metatada_As_Nodes: (key,callback)->
    data  = @.map_Issues.issue(key)
    if not data
      return callback {}
    key           = data.key
    issue_Type    = data['Issue Type'   ]
    linked_Issues = data['Linked Issues']
    targets = []
    results = []
    for name,value of data

      if ['key', 'Issue Type', 'Linked Issues'].not_Contains(name)
        param_Name = name.replace(' ','_').replace('-','_')
        options =
          node1 :
            label: issue_Type
            params:  {key: key}
          node2 :
            label: name
            params:  { "#{param_Name}": value }
          edge : "metadata"
        targets.push options


    run_Target = (options, next)=>
      @.neo4j.add_node_and_connection options, (err, response)->
        if err
          callback err, targets
        else
          results.push response
          next()

    async.eachSeries targets, run_Target, ->
      callback null, results

module.exports = Neo4j_Issues