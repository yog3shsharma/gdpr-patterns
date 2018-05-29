exec = require('child_process').exec
CONFIG = require(process.argv.slice(2)[0])

class Git_Operations
  constructor: ()->
    

  clone_GIT: ()=>
    git_url = process.env.GIT_HTTP_Url || CONFIG.jira_data_git
    exec_command = 'git clone ' + git_url + ' data'
    console.log(exec_command)
    new Promise (resolve) ->
      exec exec_command, (error, stdout, stderr) ->
        resolve('cloned')
        if error
          console.error 'ERROR ', stderr
          resolve(stderr)
        

  pull_from_GIT: () =>
    new Promise (resolve) ->
      exec 'cd data; git pull origin master; cd ..', (error, stdout, stderr) ->
        if stdout
          resolve(stdout)
        if error
          console.error 'ERROR ', stderr
          resolve(stderr)

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

  update_Mappings = (result)->
    if result.size() > 0
      console.log("Size: "  +result.size())
      await mappings_Create.all()
      console.log("pushing....")
      await push_to_GIT()
      console.log("pulling....")
      await pull_from_GIT()

  update_data_from_JIRA = ->
    new Promise (resolve) ->
      track_Queries.update_by_jql CONFIG.jql, await update_Mappings
      resolve(99)

  init = ->
    console.log("START")
    await clone_GIT()
    await pull_from_GIT()  
    setInterval  await update_data_from_JIRA, delay


module.exports = Git_Operations

