express    = require 'express'
Data       = require '../../../jira-issues/src/data'
Config     = require '../../../jira-issues/src/config'

neo4j = require('neo4j');

class Neo4J
  constructor: (options)->
    @.options       = options || {}
    @.router        = express.Router()
    @.app           = @.options.app
    @.data          = new Data()


  add_Routes: ()=>
    @.router.get  '/neo4j/cypher'            , @.cypher
    @.router.get  '/neo4j/create/:label'     , @.create
    @.router.get  '/neo4j/create-all-nodes'  , @.create_all_nodes
    @

  send_Json_Data:(req,res,json_Data)=>                    # this should be added as a global filter
    pretty = req.query?._keys().contains 'pretty'
    if pretty
      res.send "<pre>#{json_Data.json_Pretty()}</pre>"
    else
      res.json json_Data

  run_Cypher: (cypher,callback)=>

    username = Config.neo4j.username
    password = Config.neo4j.password
    uri  = "http://#{username}:#{password}@localhost:7474')"

    db = new neo4j.GraphDatabase(uri)

    data =
      query: cypher #,
      params: { },
    db.cypher data, callback

  exec_Cypher: (req, res, cypher)=>
    @.run_Cypher cypher,  (err, results)=>
      if err
        @.send_Json_Data req, res,  err
      else
        @.send_Json_Data req, res, results

  cypher: (req,res)=>
    query = req.query.query
    query ?= 'match (n:Movie) return n'

    @.exec_Cypher req, res, query




  create: (req,res)=>
    query = req.query.query
    label = req.params.label
    cypher = "CREATE (n:#{label} {"
    for key, value of req.query
      cypher += "#{key}:'#{value}',"
    cypher +="})"
    cypher = cypher.replace(",}", "}")

    console.log cypher
    @.exec_Cypher req, res, cypher


  create_all_nodes: (req, res)=>

    max_Create = 1000
    files = @.data.folder_Issues.files()
    done  = []
    create_Loop = ()=>
      next = files.pop()

      data  = next.load_Json()
      label =  data['Issue Type'].replace('-','_')
      cypher = "CREATE (n:#{label} {"


      cypher+= "id:'#{data.id}',"
      cypher+= "Priority:'#{data.Priority}',"
      cypher+= "Project:'#{data.Project}',  "
      cypher+= "Status:'#{data.Status}'"
      cypher +="})"
      console.log done.size(), cypher
      @.run_Cypher cypher, =>
        done.push next
        if done.size() > max_Create or files.size() is 0
          res.json done
        else
          create_Loop()

    create_Loop()

  #MATCH (a:risk),(b:risk)
  #  WHERE a.id = 'RISK-2' AND b.id = 'RISK-1123'
  #CREATE (a)-[r:IS_Child_OF]->(b)

module.exports = Neo4J