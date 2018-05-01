express   = require 'express'

class Debug
  constructor: (options)->
    @.options       = options || {}
    @.router        = express.Router()
    @.app           = @.options.app
    @.log_Requests  = false


  add_Routes: ()=>
    # use this to see all requests
    if @.app and @.log_Requests
      @.app.get '/*',  (req, res,next)->
        console.log req.url
        next()

    @.router.get  '/debug/ping'       , @.ping
    @

  ping: (req,res)->
    res.send ('pong')

module.exports = Debug