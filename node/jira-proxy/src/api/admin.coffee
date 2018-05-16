express   = require 'express'
fs = require('fs-extra')

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
    @.router.put    '/admin/env'        , @.putEnv
    @.router.post   '/admin/env'        , @.putEnv
    @.router.get    '/admin/countfiles' , @.getCountFiles
    @.router.delete    '/admin/datafolder' , @.deleteDataFolder
    @

  ping: (req,res)->
    res.send ('pong')

  deleteDataFolder: (req,res)->
    pathname = require('path').dirname(require.main.filename)+ "/../data"
    console.log("deleteing " + pathname)
    fs.removeSync(pathname)
    res.send {"exit": 0}
       
  getEnv: (req,res)->
    environment_vars = {
      Jira_Protocol: process.env.Jira_Protocol,
      Jira_Host: process.env.Jira_Host,
      Jira_Username: process.env.Jira_Username,
      Jira_Password: process.env.Jira_Password.length
    }
    res.send environment_vars

  putEnv: (req,res)->
    process.env.Jira_Protocol = req.query.Jira_Protocol
    process.env.Jira_Host = req.query.Jira_Host
    process.env.Jira_Username = req.query.Jira_Username
    process.env.Jira_Password = req.query.Jira_Password
    #console.log(req.query)
    res.send {}


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