#!/usr/bin/env coffee
require 'fluentnode'


Track_Queries   = require '../node/jira-issues/src/jira/track-queries'
Mappings_Create = require '../node/jira-mappings/src/create.coffee'
Admin_Functions = require '../node/jira-proxy/src/api/admin.coffee'
Save_Data = require '../node/jira-issues/src/jira/save-data.coffee'
http = require 'http'

Jira_Setup = require '../node/jira-proxy/src/api/jira-server.coffee'


CONFIG = require(process.argv.slice(2)[0])
exec = require('child_process').exec

git_url = process.env.GIT_HTTP_Url || CONFIG.jira_data_git
gdpr_app = process.env.GDPR_APP || CONFIG.GDPR_APP

track_Queries   = new Track_Queries()
mappings_Create = new Mappings_Create()
admin_functions = new Admin_Functions()
save_data = new Save_Data()
jira_setup = new Jira_Setup()

delay         = 30 * 1000

clone_GIT = ->
  exec_command = 'git clone ' + git_url + ' data'
  new Promise (resolve) ->
    exec exec_command, (error, stdout, stderr) ->
      if stdout
        console.log 'GIT CLONED'
        #resolve(99)
      if error
        console.error 'ERROR ', stderr
        #resolve(99)
      resolve(99)

pull_from_GIT = ->
  new Promise (resolve) ->
    exec 'cd data; git pull origin master; cd ..', (error, stdout, stderr) ->
      if stdout
        console.log 'GIT PULLED'
        #resolve(99)
      if error
        console.error 'ERROR ', stderr
      resolve(99)

push_to_GIT = ->
  exec_command = 'cd data; git add --all; git commit -m "' + new Date().getTime() + '"; git push; cd ..'
  new Promise (resolve) ->
    exec exec_command, (error, stdout, stderr) ->
      if stdout
        console.log 'GIT PUSHED'
        #resolve(99)
      if error
        console.error 'ERROR ', stderr
      resolve(99)

get_http = (end_point) ->
  new Promise (resolve) ->
    req = http.get end_point, (res) ->
      resolve(res.statusCode)
    req.on 'error', ->
      resolve(500)

init_db_and_graph = ->
  "/api/admin/datafolder"
  arr = [
    "/api/neo4j/delete/all?pretty",
    "/api/admin/git/clone",
    "/api/admin/git/pull",
    "/api/neo4j/nodes/create-regex/VULN?pretty",
    "/api/neo4j/nodes/create-regex/SEC?pretty",
    "/api/neo4j/nodes/create-regex/GDPR?pretty",
    "/api/neo4j/nodes/create-regex/RISK?pretty",
    "/api/neo4j/nodes/create-regex/TM?pretty"
  ]
  for value in arr
    try
      http_code = await get_http(gdpr_app + value)
      console.log(http_code + " > " + gdpr_app + value)
    catch e
      console.error 'oops'


update_Mappings = (result)->
  if result.size() > 0
    console.log("Size: "  +result.size())
    await mappings_Create.all()
    console.log("pushing....")
    await push_to_GIT()
    console.log("pulling....")
    await pull_from_GIT()

    console.log("Init DB and Graph")
    init_db_and_graph()

update_data_from_JIRA = ->
  new Promise (resolve) ->
    track_Queries.update_by_jql CONFIG.jql, await update_Mappings
    resolve(99)

init = ->
  console.log("START")
  await clone_GIT()
  await pull_from_GIT()  
  await jira_setup.setup_init()
  await track_Queries.create  'open-projects', CONFIG.jql
  setInterval await update_data_from_JIRA, delay


init()
#init_db_and_graph()

