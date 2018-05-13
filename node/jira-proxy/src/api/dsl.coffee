express   = require 'express'
Exec_Code = require '../dsl/exec-code'

class Dsl
  constructor: (options)->
    @.options       = options || {}
    @.router        = express.Router()
    @.app           = @.options.app
    @.exec_Code     = new Exec_Code()

  add_Routes: ()=>
    @.router.get  '/dsl/exec'         , @.exec
    @

  exec: (req,res)=>
    code = req.query.code
    if not code
      return res.send ('code must be provided')

    result = @.exec_Code.coffee(code)

    if result instanceof Promise          #todo: move this variation to @.exec_Code function
      result.then (data)->
        res.json data
      result.catch (err)->
        res.json err
      return
    if result instanceof Error
      return res.json error: result.toString()
    if typeof result is "object"
      return res.json result
    else
      res.send result.toString()

module.exports = Dsl