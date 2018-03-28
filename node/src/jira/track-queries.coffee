# this class supports the tracking of particular queries and the auto update of them
Save_Data = require '../jira/save-data'

class Track_Queries
  constructor : ->
    @.save_Data = new Save_Data()
    @.data      = @.save_Data.data
    @.file_Tracked_Queries = @.data.folder_Data.path_Combine('tracked_Queries.json')

    if @.file_Tracked_Queries.file_Not_Exists()
      {}.save_Json @.file_Tracked_Queries

  create: (name, jql)->
    queries = @.current()
    if queries[name]
      queries[name].jql = jql
    else
      queries[name] =
          jql         : jql
          last_updated: null
          issues_saved: 0
    queries.save_Json @.file_Tracked_Queries

  current :->
    return @.file_Tracked_Queries.load_Json()

  delete:(name)->
    queries = @.current()
    delete queries[name]
    queries.save_Json @.file_Tracked_Queries

  now_Date :->
    now  = new Date(new Date().getTime() - new Date().getTimezoneOffset()*60*1000)  # adjusted for the timezone
    return now.toISOString().replace('T',' ').substr(0, 16);

  update: (name, callback)->
    queries = @.current()
    query   = queries[name]
    if query
      jql = query.jql
      if query.last_updated
        jql += " and updated >= '#{query.last_updated}'"
      console.log "Updating tracked files '#{name}' using jql: #{jql}"

      now_date = @.now_Date()
      @.save_Data.save_Issues jql, (result)=>
        if result.size() > 0
          query.last_updated = now_date
          query.issues_saved = result.size()
          console.log "Updated #{query.issues_saved} issues"
          queries.save_Json @.file_Tracked_Queries

        callback result


module.exports = Track_Queries