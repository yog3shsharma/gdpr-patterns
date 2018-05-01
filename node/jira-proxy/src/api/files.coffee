express   = require 'express'

class Debug
  constructor: (options)->
    @.options       = options || {}
    @.router        = express.Router()
    @.app           = @.options.app
    @.log_Requests  = false


  add_Routes: ()=>
    @.router.get  '/js'           , @.js_neovis
    @.router.get  '/js/neovis.js'        , @.js_neovis
    @.router.get  '/js/ping'       , @.ping
    @

  ping: (req,res)->
    root_Dir    = (wallaby? || '.').real_Path()
    res.send root_Dir

  js_neovis : (req, res)->
    root_Dir    = (wallaby?.localProjectDir.path_Combine('..') || '.')

    neovis_Dir  = root_Dir.path_Combine('../neovis.js')

    neovis_File = neovis_Dir.path_Combine('dist/neovis.js')
    #return res.send neovis_File.file_Exists()
    res.send neovis_File.file_Contents()



module.exports = Debug