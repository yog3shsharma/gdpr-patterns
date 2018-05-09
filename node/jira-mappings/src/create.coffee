Data      = require './util/data'
Map_Files = require './map-files'

class Create
  constructor:->
    @.data = new Data()

  all: ->
    #console.log "Creating all mappings"
    result = []
    result.push @.map_Files()
    result

  map_Files: =>
    return new Map_Files(@.data).create()

  files: =>
    @.data.file_Issue_Files.load_Json()

module.exports = Create