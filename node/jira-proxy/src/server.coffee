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

    Api_Debug = require './api/debug'

    @.app.use api_Path   ,new Api_Debug(  app:@.app).add_Routes().router

    #@.app.use api_Path   , new Api_Debug(  app:@.app).add_Routes().router


    #set hugo proxy
    Hugo_Proxy = require './hugo-proxy'
    @.app.use '/', new Hugo_Proxy(app:@.app).add_Routes().router
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