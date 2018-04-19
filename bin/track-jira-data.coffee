#!/usr/bin/env coffee
require 'fluentnode'

Track_Queries   = require '../node/jira-issues/src/jira/track-queries'
Mappings_Create = require '../node/jira-mappings/src/create.coffee'

track_Queries   = new Track_Queries()
mappings_Create = new Mappings_Create()

delay         = 60 * 1000

update_Mappings = (result)->
  if result.size() > 0
    mappings_Create.all()

update_Data = ->
  track_Queries.update 'gdpr-project', update_Mappings
  track_Queries.update 'risk-project', update_Mappings

console.log '************************************************************'
console.log "** Tracking jira updates every #{delay/1000} seconds"
console.log '************************************************************'

update_Data()
setInterval  update_Data, delay


