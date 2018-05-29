Map_Issues = require '../../../jira-mappings/src/map-issues'
Save_Data  = require '../../../jira-issues/src/jira/save-data'
Neo4j      = require '../neo4j/neo4j'

class Neo4j_Issues
  constructor:->
    #@.data = new Data()
    @.map_Issues = new Map_Issues()
    @.save_Data  = new Save_Data()
    @.neo4j = new Neo4j()

  add_Issue: (key)=>
    results = []
    @.save_Data.get_Issue key, (raw_Data)=>                        # will force load if issue doesn't exist locally
      if (not raw_Data?.key)                                          # to handle issue rename
        return results
      key = raw_Data.key
      data    = @.map_Issues.issue(key)
      label = data['Issue Type']
      node_Result          = await @.neo4j.merge_node label, data
      if node_Result
        results.push node_Result
      return results = []

  add_Issues: (keys)=>
    results = []
    for key in keys
      results.add await @.add_Issue(key)
    return results


  add_Issue_And_Linked_Nodes: (key)=>
    results = []
    @.save_Data.get_Issue key, (raw_Data)=>                        # will force load if issue doesn't exist locally
      if (not raw_Data?.key)                                          # to handle issue rename
        return results
      key = raw_Data.key
      data    = @.map_Issues.issue(key)
      if data
        label = data['Issue Type']
        node_Result          = await @.neo4j.merge_node label, data
        linked_Issues_Result = await @.add_Issue_Linked_Issues_As_Single_Nodes key
        if node_Result
          results.push node_Result
        else
          console.log "[add_Issue_And_Linked_Nodes] no node_Result for key: #{key}"

        if linked_Issues_Result
          results = results.concat linked_Issues_Result

      return results

  add_Issue_As_Nodes: (id,callback)->
    @.add_Issue_Linked_Issues_As_Single_Nodes id, (err, results)->
      callback err, results

#  add_Issue_As_Nodes_with_Metadata: (id,callback)->
#    @.add_Issue_Metatada_As_Nodes id, (err, results1)=>
#      if err
#        callback err, results1
#      else
#        @.add_Issue_Linked_Issues_As_Single_Nodes id, (err, results2)->
#          result =  results1.concat results2
#          callback err, result

  add_Issues_As_Nodes: (ids)->
    results = []

    for id in ids
      id_Results = await @.add_Issue_And_Linked_Nodes id
      if id_Results
        results = results.concat id_Results
      else
        console.log "[add_Issues_As_Nodes] no results for id: #{id}"
    return results

#  add_Issue_Metatada_As_Nodes: (key, filters)->
#    results = []
#    data  = @.map_Issues.issue(key)
#    if not data
#      return results
#    issue_Key     = data.key
#    issue_Type    = data['Issue Type'   ]
#    targets = []
#
#    issue_Root_Node_to_Metadata =
#      source_label : issue_Type
#      source_key   : issue_Key
#      target_label : "metadata"
#      target_key   : issue_Key
#      edge_label   : "metadata"
#    targets.push  issue_Root_Node_to_Metadata
#
#    for name,value of data
#      if not value
#        continue
#      if filters and not filters.contains name
#        continue
#      if ['key', 'Issue Type', 'Linked Issues'].not_Contains(name)
#        options =
#          source_label : "metadata"
#          source_key   : issue_Key
#          target_label : name
#          target_key   : value
#          edge_label   : name
#        targets.push options
#
#    for target in targets
#      results.push await @.neo4j.add_node_and_connection target
#    return results

  add_Issue_Metatada_As_Nodes: (key, filters)->
    results = []
    data  = @.map_Issues.issue(key)
    if not data
      return results
    issue_Key     = data.key
    issue_Type    = data['Issue Type'   ]
    targets = []

    for name,value of data
      if not value
        continue
      if filters and not filters.contains name
        continue
      if ['key', 'Issue Type', 'Linked Issues'].not_Contains(name)
        options =
          source_label : issue_Type
          source_key   : issue_Key
          target_label : name
          target_key   : value
          edge_label   : name
        targets.push options

    for target in targets
      results.push await @.neo4j.add_node_and_connection target
    return results

  add_Issues_Metatada_As_Nodes: (ids, filters)=>
    results = []

    for id in ids
      id_Results = await @.add_Issue_Metatada_As_Nodes id, filters
      if id_Results
        results = results.concat id_Results
      else
        console.log "[add_Issues_As_Nodes] no results for id: #{id}"
    return results

  add_Issue_Linked_Issues_As_Single_Nodes: (key,callback)->
    data  = @.map_Issues.issue(key)

    if not data
      callback?()
      return []

    issue_Key     = data.key
    issue_Type    = data['Issue Type'   ]
    linked_Issues = data['Linked Issues']
    targets = []
    results = []

    if !linked_Issues
      return null

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

    run_Target = (options)=>
      @.neo4j.add_node_and_connection options, (err, response)->
        if err
          results.push err
          #callback err, targets
        else
          results.push response

    for target in targets
      await run_Target target
    callback? null, results
    return results

  add_Linked_Issues_As_Full_Nodes: (key)->
    data  = @.map_Issues.issue(key)
    if not data
      return {}

    linked_Issues = data['Linked Issues']
    ids =  (item.key for item in linked_Issues)
    @.add_Issues_As_Nodes ids


module.exports = Neo4j_Issues