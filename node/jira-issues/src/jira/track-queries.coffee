# this class supports the tracking of particular queries and the auto update of them
Save_Data = require '../jira/save-data'

class Track_Queries
  constructor : ->
    @.save_Data = new Save_Data()
    @.data      = @.save_Data.data

  create: (name, jql)->
    #queries = @.current()
    #query   = queries['open-projects']

    queries = @.current()
    if !queries[name]
      queries[name] =
          jql         : jql
          last_updated: null
          issues_saved: 0
    queries.save_Json @.data.file_Tracked_Queries

  current :->
    return @.data.file_Tracked_Queries.load_Json() || {}

  delete:(name)->
    queries = @.current()
    if queries[name]
      delete queries[name]
      queries.save_Json @.data.file_Tracked_Queries
      return true
    else
      return false

  now_Date :->
    now  = new Date(new Date().getTime() - new Date().getTimezoneOffset()*60*1000)  # adjusted for the timezone
    return now.toISOString().replace('T',' ').substr(0, 16)
    

  update: (name, callback)->

    queries = @.current()
    query   = queries[name]

    if query is undefined
      console.log "[Track_Queries][update] query not found #{name}"
    else
      jql = query.jql
      console.log(jql)
      if query.last_updated
        jql += " and updated >= #{query.last_updated}"
      console.log "Updating tracked files '#{name}' using jql: #{jql}"

      now_date = @.now_Date()
      @.save_Data.save_Issues jql, (result)=>
        if result.size() > 0
          query.last_updated = new Date().getTime() #now_date
          query.issues_saved = result.size()
          console.log "Updated #{query.issues_saved} issues"
          queries.save_Json @.data.file_Tracked_Queries

        callback result
  
  update_by_jql: (callback)->
    name = 'open-projects'

    queries = @.current()
    query   = queries[name]

    if query is undefined
      console.log "[Track_Queries][update] query not found #{name}"
    else
      if query.last_updated
        jql = query.jql + " and updated >= #{query.last_updated}"
      else
        jql = query.jql

      console.log "JQL files '#{name}' using jql: #{jql}"

      @.save_Data.save_Issues jql, (result)=>
        console.log(result.size)
        if result.size() > 0
          query.last_updated = new Date().getTime()
          query.jql = query.jql
          query.issues_saved = result.size()
          queries.save_Json @.data.file_Tracked_Queries

        callback result

  download_by_jql: (callback)->
    name = 'open-projects'

    queries = @.current()
    query   = queries[name]

    if query is undefined
      console.log "[Track_Queries][update] query not found #{name}"
    else
      console.log(query.jql)
      @.save_Data.save_Issues query.jql, (result)=>
        console.log(result.size())
        if result.size() > 0
          query.last_updated = new Date().getTime()
          query.jql = query.jql
          query.issues_saved = result.size()
          queries.save_Json @.data.file_Tracked_Queries

        callback result

module.exports = Track_Queries