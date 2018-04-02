#!/usr/bin/env coffee

require 'fluentnode'

console.log "\n***************************"
console.log   "*** Starting Jira proxy ***"
console.log   "***************************\n"

Server = require '../node/jira-proxy/src/server.coffee'
using new Server, ->
  @.run()
  console.log "Server started at #{@.server_Url()}"