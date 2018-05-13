#Data      = require './util/data'
Data       = require '../../jira-issues/src/data'
Map_Issues = require './map-issues'
Map_Files  = require './map-files'

class Create

  constructor: ->
    @.data = new Data()
    @.map_Issues = new Map_Issues(@.data)
    @.map_Files  = new Map_Files(@.data)

  all: =>
    console.log "Creating all mappings"
    result = []
    result.push @.map_Files.create()                   .file_Name()
    result.push @.map_Issues.map_Issues_by_Key()       .file_Name()
    result.push @.map_Issues.map_Issues_by_Properties().file_Name()
    result

  files: =>
    @.data.file_Issue_Files.load_Json()

module.exports = Create