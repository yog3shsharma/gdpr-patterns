Data         = require './data'

jira_Details = new Data().folder_Data.path_Combine('config.json').load_Json()

config_data =
  via_config : jira_Details?
  protocol   : process.env.Jira_Protocol   || jira_Details?.protocol   || 'https',
  host       : process.env.Jira_Host       || jira_Details?.host       || '{host}'    ,
  username   : process.env.Jira_Username   || jira_Details?.username   || '{username}',
  password   : process.env.Jira_Password   || jira_Details?.password   || '{password}',
  apiVersion : process.env.Jira_ApiVersion || jira_Details?.apiVersion || 'latest'   ,
  strictSSL  : false
  neo4j      : {
    url     : process.env.Neo4J_Url      || "bolt://localhost:7687"
    username: process.env.Neo4J_Username || 'neo4j',
    password: process.env.Neo4J_Password || 'test' }


module.exports = config_data
