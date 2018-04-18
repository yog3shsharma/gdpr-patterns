express    = require 'express'
Data       = require '../../../jira-issues/src/data'
Neo4J_Api  = require '../neo4j/neo4j'

class Neo4J
  constructor: (options)->
    @.options       = options || {}
    @.router        = express.Router()
    @.app           = @.options.app
    @.data          = new Data()
    @.neo4j         = new Neo4J_Api()


  add_Routes: ()=>
    @.router.get  '/neo4j/cypher'            , @.cypher
    @.router.get  '/neo4j/create/:label'     , @.create
    @.router.get  '/neo4j/delete/all'        , @.delete_all

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

  create: (req,res)=>       # refactor
    query = req.query.query
    label = req.params.label
    cypher = "CREATE (n:#{label} {"
    for key, value of req.query
      cypher += "#{key}:'#{value}',"
    cypher +="})"
    cypher = cypher.replace(",}", "}")

    @.exec_Cypher req, res, cypher

  delete_all: (req, res)=>
    @.neo4j.delete_all_nodes (err, response)=>
      @.send_Json_Data req, res, response
#
#
#  create_all_nodes: (req, res)=>
#    max_Create = 1000
#    files = @.data.folder_Issues.files()
#    done  = []
#    create_Loop = ()=>
#      next = files.pop()
#
#      data  = next.load_Json()
#      label =  data['Issue Type'].replace('-','_')
#      cypher = "CREATE (n:#{label} {"
#
#
#      cypher+= "id:'#{data.id}',"
#      cypher+= "Priority:'#{data.Priority}',"
#      cypher+= "Project:'#{data.Project}',  "
#      cypher+= "Status:'#{data.Status}'"
#      cypher +="})"
#      console.log done.size(), cypher
#      @.run_Cypher cypher, =>
#        done.push next
#        if done.size() > max_Create or files.size() is 0
#          res.json done
#        else
#          create_Loop()
#
#    create_Loop()

  #MATCH (a:risk),(b:risk)
  #  WHERE a.id = 'RISK-2' AND b.id = 'RISK-1123'
  #CREATE (a)-[r:IS_Child_OF]->(b)

module.exports = Neo4J