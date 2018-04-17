Data      = require './util/Data'
Map_Files = require './map-files'

class Create
  constructor:->
    @.data = new Data()

  all: ->
    console.log "Creating all mappings"
    @.map_Files()

  map_Files    : => return new Map_Files(@.data).create()

  files        : =>  @.data.file_Issue_Files.load_Json()

module.exports = Create