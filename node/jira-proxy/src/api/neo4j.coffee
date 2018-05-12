express      = require 'express'
Data         = require '../../../jira-issues/src/data'
Neo4J_Api    = require '../neo4j/neo4j'
Neo4j_Issues = require '../neo4j/neo4j-issues'

class Neo4J
  constructor: (options)->
    @.options       = options || {}
    @.router        = express.Router()
    @.app           = @.options.app
    @.data          = new Data()
    @.neo4j         = new Neo4J_Api()
    @.neo4j_Issues  = new Neo4j_Issues()


  add_Routes: ()=>
    @.router.get  '/neo4j/cypher'                                    , @.cypher
    @.router.get  '/neo4j/delete/all'                                , @.delete_all

    @.router.get  '/neo4j/nodes/add-Issue-and-Linked-Nodes/:id'      , @.add_Issue_And_Linked_Nodes
    @.router.get  '/neo4j/nodes/add-Issue-Metatada-as-Nodes/:id'     , @.add_Issue_Metatada_As_Nodes
    @.router.get  '/neo4j/nodes/add-Issues-Metatada-as-Nodes/:regex' , @.add_Issues_Metatada_As_Nodes
    @.router.get  '/neo4j/nodes/create/:ids'                         , @.nodes_Create
    @.router.get  '/neo4j/nodes/create-regex/:regex'                 , @.nodes_Create_via_Filter

    #todo refactor the direct node creation capability (will be needed for the dsl
    #@.router.get  '/neo4j/create/:label'                  , @.create
    #@.router.get  '/neo4j/nodes/create/:id'           , @.nodes_Create
#    @.router.get  '/neo4j/create-all-nodes'  , @.create_all_nodes
    @

  send_Json_Data:(req,res,json_Data)=>                    # this should be added as a global filter
    pretty = req.query?._keys().contains 'pretty'
    if pretty
      res.send "<pre>#{json_Data.json_Pretty()}</pre>"
    else
      res.json json_Data

  exec_Cypher: (req, res, cypher)=>
    @.neo4j.run_Cypher cypher, {},  (err, results)=>
      if err
        @.send_Json_Data req, res,  err
      else
        @.send_Json_Data req, res, results

  cypher: (req,res)=>
    query = req.query.query
    query ?= 'match (n:Movie) return n'

    @.exec_Cypher req, res, query
  
#  create: (req,res)=>       # refactor
#    #query = req.query.query
#    label = req.params.label
#    cypher = "CREATE (n:#{label} {"
#    for key, value of req.query
#      cypher += "#{key}:'#{value}',"
#    cypher +="})"
#    cypher = cypher.replace(",}", "}")
#
#    @.exec_Cypher req, res, cypher

  delete_all: (req, res)=>
    @.neo4j.delete_all_nodes (err, response)=>      
      @.send_Json_Data req, res, response

  add_Issue_And_Linked_Nodes: (req,res)=>
    id = req.params.id
    results = await @.neo4j_Issues.add_Issue_And_Linked_Nodes id
    @.send_Json_Data req, res, { nodes_created : results.size?(), results : results }


  add_Issue_Metatada_As_Nodes: (req, res)=>
    id      = req.params.id
    filters = req.query.filters?.split(',')
    results = await @.neo4j_Issues.add_Issue_Metatada_As_Nodes id, filters
    @.send_Json_Data req, res, { nodes_created : results.size?(), results : results }

  add_Issues_Metatada_As_Nodes: (req, res)=>
    regex   = req.params.regex
    filters = req.query.filters?.split(',')
    ids     = @.neo4j_Issues.map_Issues.issues.ids()
    matches = (id for id in ids when id.match(regex))

    results = await @.neo4j_Issues.add_Issues_Metatada_As_Nodes matches, filters
    @.send_Json_Data req, res, { regex: regex , matches_size: matches.size(), nodes_created: results.size(), matches : matches}

  nodes_Create: (req,res)=>
    ids = req.params.ids.split(',')

    results = await @.neo4j_Issues.add_Issues_As_Nodes ids

    @.send_Json_Data req, res, nodes_created: results.size?(), results: results


  nodes_Create_via_Filter : (req,res)=>
    regex   = req.params.regex
    ids     = @.neo4j_Issues.map_Issues.issues.ids()
    matches = (id for id in ids when id.match(regex))

    results = await @.neo4j_Issues.add_Issues_As_Nodes matches
    @.send_Json_Data req, res, { regex: regex , matches_size: matches.size(), nodes_created: results.size(), matches : matches}

module.exports = Neo4J