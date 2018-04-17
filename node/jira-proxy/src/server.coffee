require 'fluentnode'

express = require 'express'

class Server
  constructor: (options)->
    @.app         = null
    @.options     = options || {}
    @.server      = null
    @.port        = @.options.port || process.env.PORT || 3000



  add_Routes_Api: ()->
    api_Path   = '/api'

    add_Routes = (api_Path, module_Path)=>
      Module = require  module_Path
      @.app.use api_Path   ,new Module(  app:@.app).add_Routes().router

    add_Routes '/api', './api/debug'
    add_Routes '/api', './api/jira'
    add_Routes '/api', './api/neo4j'

    add_Routes '/'   , './hugo-proxy' #set hugo proxy


    #Api_Debug = require './api/debug'
    #Api_Jira  = require './api/jira'

    #@.app.use api_Path   ,new Api_Debug(  app:@.app).add_Routes().router
    #@.app.use api_Path   ,new Api_Jira(  app:@.app).add_Routes().router



    #set hugo proxy
    #Hugo_Proxy = require './hugo-proxy'
    #@.app.use '/', new Hugo_Proxy(app:@.app).add_Routes().router
    @

  run: (random_Port)=>
    if random_Port
      @.port = 23000 + 3000.random()
    @.setup_Server()
    @.add_Routes_Api()
    @.setup_Routes()
    @.start_Server()
    @

  setup_Server: =>
    @.app = express()
    @

  setup_Routes: =>
    @.app.get '/',  (req, res)->
      res.send 'Jira proxy server'

    @.app.use (err, req, res, next) ->
      res.status(500).render('error', error: err, stack: err.stack)


  start_Server: =>
    @.server = @.app.listen @.port

  server_Url: =>
    "http://localhost:#{@.port}"

  stop: (callback)=>
    if @.server
      @.server.close =>
        callback() if callback

module.exports = Server