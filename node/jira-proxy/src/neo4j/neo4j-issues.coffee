Map_Issues = require '../../../jira-mappings/src/map-issues'
Neo4j      = require '../neo4j/neo4j'
async      = require 'async'

class Neo4j_Issues
  constructor:->
    #@.data = new Data()
    @.map_Issues = new Map_Issues()
    @.neo4j = new Neo4j()

#  add_Issue: (id, callback)=>
#    data  = @.map_Issues.issue(id)
#    data['Linked Issues'] = data['Linked Issues'].size()
#    #delete data['Linked Issues']
#    label = data['Issue Type']
#    @.neo4j.create_node label, data, callback
#
#  add_Issues: (ids, callback)=>
#    result = []
#    add_Helper = (id, next)=>
#      @.add_Issue id, (err, data)=>
#        if err
#          callback null, result
#        else
#          added_Id = data.records[0]._fields[0].properties.id
#          result.push added_Id
#          next()

#    async.eachSeries ids, add_Helper, ()->
#      callback null, result


  add_Issue_As_Nodes: (id,callback)->
    @.add_Issue_Linked_Issues_As_Single_Nodes id, (err, results)->
      callback err, results

  add_Issue_As_Nodes_with_Metadata: (id,callback)->
    @.add_Issue_Metatada_As_Nodes id, (err, results1)=>
      if err
        callback err, results1
      else
        @.add_Issue_Linked_Issues_As_Single_Nodes id, (err, results2)->
          result =  results1.concat results2
          callback err, result

  add_Issues_As_Nodes: (ids, callback)->
    results = []
    add_Helper = (id, next)=>
      @.add_Issue_As_Nodes id, (err, partial_Result)=>
      #
      #@.add_Issue_As_Nodes_with_Metadata id, (err, partial_Result)=>
        if err
          callback null, results
        else
          results = results.concat partial_Result
          next()
    async.eachSeries ids, add_Helper, ()->
      callback null, results

  add_Issue_Metatada_As_Nodes: (key,callback)->
    data  = @.map_Issues.issue(key)
    if not data
      return callback {}
    issue_Key     = data.key
    issue_Type    = data['Issue Type'   ]
    targets = []
    results = []

    for name,value of data
      if not value
        continue
      if ['key', 'Issue Type', 'Linked Issues'].not_Contains(name)
        options =
          source_label : "metadata"
          source_key   : issue_Key
          target_label : name
          target_key   : value
          edge_label   : name
        targets.push options


    add_metadata_node = (next)=>
      options =
        source_label : issue_Type
        source_key   : issue_Key
        target_label : "metadata"
        target_key   : issue_Key
        edge_label   : "metadata"
      targets.push options
      @.neo4j.add_node_and_connection options, next


    run_Target = (options, next)=>
      @.neo4j.add_node_and_connection options, (err, response)->
        if err
          console.log options
          callback err, targets
        else
          results.push response
          next()

    add_metadata_node ->
      async.eachSeries targets, run_Target, ->
        callback null, results

  add_Issue_Linked_Issues_As_Single_Nodes: (key,callback)->
    data  = @.map_Issues.issue(key)
    if not data
      return callback {}

    issue_Key     = data.key
    issue_Type    = data['Issue Type'   ]
    linked_Issues = data['Linked Issues']
    targets = []
    results = []

    for issue in linked_Issues
      linked_Issue = @.map_Issues.issue(issue.key)          # doing this here is highly inefficient (this mapping needs to be done when mapping the Linked Issues)
      options =
        source_label : issue_Type
        source_key   : issue_Key
        #target_label : issue.type
        target_label : linked_Issue?['Issue Type'] || 'ISSUE'    # we need to use this so that the links point to the correct node
        target_key   : issue.key
        edge_label   : issue.type
        #edge_label   : issue.direction
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


  add_Linked_Issues_As_Full_Nodes: (key,callback)->
    data  = @.map_Issues.issue(key)
    if not data
      return callback {}

    linked_Issues = data['Linked Issues']
    ids =  (item.key for item in linked_Issues)
    @.add_Issues_As_Nodes ids, callback


module.exports = Neo4j_Issues