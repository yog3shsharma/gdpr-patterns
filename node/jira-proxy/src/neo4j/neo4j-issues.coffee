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



  add_Issue_And_Linked_Nodes_ASYNC: (key)=>
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

  add_Issues_As_Nodes: (ids)->
    for id in ids
      @.add_Issue id
    return null
 
  add_Issues_As_Links: (ids)->
    @.link_all_nodes ids
    return null

  link_all_nodes: (keys)->
    key = keys[0]
    if not key
      return
    #console.log key
    @.save_Data.get_Issue key, (raw_Data)=>                        # will force load if issue doesn't exist locally
      if (not raw_Data?.key)                                          # to handle issue rename
        @.link_all_nodes keys[1..]
        return 0
      key = raw_Data.key
      data = @.map_Issues.issue(key)

      if data
        for link in data['Linked Issues']
          link_name = link['type'].replace(/\s/g,'_').replace(/-/g,'_')
          Issue_Type = data['Issue Type'].replace(/\s/g,'_').replace(/-/g,'_')
          await @.neo4j.add_Edge2 key, link_name, link['key']
          console.log key
        @.link_all_nodes keys[1..]
      else
        @.link_all_nodes keys[1..]

  link_nodes: (key)->

    @.save_Data.get_Issue key, (raw_Data)=>                        # will force load if issue doesn't exist locally
      if (not raw_Data?.key)                                          # to handle issue rename
        console.log 'b'
        return 0
      key = raw_Data.key
      data = @.map_Issues.issue(key)

      if data
        cnt = 2 
        for link in data['Linked Issues']
          link_name = link['type'].replace(/\s/g,'_').replace(/-/g,'_')
          Issue_Type = data['Issue Type'].replace(/\s/g,'_').replace(/-/g,'_')
          #console.log Issue_Type, ":", key, '===', link_name, '===' , link['key']

          end_key = link['key']
          await @.neo4j.add_Edge2 key, link_name, end_key
          console.log "done", key
          cnt = cnt+1
        console.log 's'
        return cnt
      else
        console.log 'a'
        return 0
          #@.save_Data.get_Issue end_key, (raw_Data2)=>
          #  if (raw_Data2?.key)
          #    end_data = @.map_Issues.issue_if_exist(end_key)
          #    #console.log end_data
          #    if end_data
          #      if end_data['Summary']
          #        end_Issue_Type = end_data['Issue Type'].replace(/\s/g,'_').replace(/-/g,'_')
          #        console.log Issue_Type, key, '->', link_name, "->", end_Issue_Type, end_key
          #        #@.neo4j.add_Edge Issue_Type, key, link_name, end_Issue_Type, end_key
          #        @.neo4j.add_Edge2 key, link_name, end_key
          #@.neo4j.add_Edge data['key'], data
        #label = data['Issue Type']
        #node_Result          = await @.neo4j.merge_node label, data
        #linked_Issues_Result = await @.add_Issue_Linked_Issues_As_Single_Nodes key
        #if node_Result
        #  results.push node_Result
        #else
        #  console.log "[add_Issue_And_Linked_Nodes] no node_Result for key: #{key}"

        #if linked_Issues_Result
        #  results = results.concat linked_Issues_Result


  
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
    #console.log key
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