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
    add_Routes '/api', './api/dsl'
    add_Routes '/api', './api/jira'
    add_Routes '/api', './api/jira-server'
    add_Routes '/api', './api/neo4j'
    add_Routes '/api', './api/files'
    add_Routes '/api', './api/admin'
    add_Routes '/'   , './hugo-proxy'  # set hugo proxy
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