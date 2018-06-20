express   = require 'express'
fs = require('fs-extra')
Git_Operations = require './git_data/track-jira-data.coffee'

class Admin
  constructor: (options)->
    @.options       = options || {}
    @.router        = express.Router()
    @.app           = @.options.app
    #@.envs           = new envs()
    @.log_Requests  = false


  add_Routes: ()=>
    if @.app and @.log_Requests
      @.app.get '/*',  (req, res,next)->
        console.log req.url
        next()

    @.router.get    '/admin/ping'       , @.ping
    @.router.get    '/admin/env'        , @.getEnv
    @.router.get    '/admin/git/pull' , @.getGitPull
    @.router.get    '/admin/git/clone' , @.getGitClone
    @.router.get    '/admin/countfiles' , @.getCountFiles
    @.router.delete    '/admin/datafolder' , @.deleteDataFolder
    @

  ping: (req,res)->
    res.send 'pong'

  getGitPull: (req,res)->
    res.send await new Git_Operations().pull_from_GIT()

  getGitClone: (req,res)->
    res.send await new Git_Operations().clone_GIT()



  deleteDataFolder_NoHTTP=(pathname) ->
    pathname = require('path').dirname(require.main.filename)+ "/../data"
    console.log("Deleting " + pathname)
    fs.removeSync(pathname)
  
  deleteDataFolder: (req,res)->
    deleteDataFolder_NoHTTP()
    res.send {"exit": 0}
       
  getEnv: (req,res)->
    environment_vars = {
      Jira_Protocol: process.env.Jira_Protocol,
      Jira_Host: process.env.Jira_Host,
      Jira_Username: process.env.Jira_Username,
      Jira_Password: process.env.Jira_Password
    }

    if process.env.Jira_Password
      environment_vars.Jira_Password = true
    else
      environment_vars.Jira_Password = false
    
    res.json environment_vars


  countFolderSize=(pathname) ->
    cnt = 0
    try
      fs.readdirSync(pathname).forEach (file) ->
          stats = fs.lstatSync(pathname + "/" + file)
          if stats.isDirectory()
            cnt += countFolderSize(pathname+"/"+file)
          else 
            cnt++
    catch e
      console.error("No file or direcotry: "  + pathname)
    finally
      return cnt


  getCountFiles: (req,res)->
    res_data = {
      path: require('path').dirname(require.main.filename),
      files: 0
    }

    res_data.path = res_data.path + "/../data"
    res_data.files = countFolderSize(res_data.path)
    
    res.send res_data

module.exports = Admin