Issues    = require '../src/util/issues'

class Map_Issues
  constructor: ->
    @.issues = new Issues()

  issue: (id)->
    fields_Schema = @.issues.fields_Schema()

    raw_Issue = @.issues.issue_Raw_Data(id)
    if raw_Issue

      result = {}
      types = []
      #console.log fields_Schema
      for key,value of raw_Issue
        if fields_Schema[key]
          field_Name         = fields_Schema[key].name
          field_Type         = fields_Schema[key].schema_Type_Name
          types.push field_Type
          result[field_Name] = @.get_Data_By_Type field_Type, value
          if result[field_Name] is null
            break
      return result

    return null

  get_Data_By_Type: (field_Type, raw_Data)->
    parser =
      any            : (raw)-> return raw
      array          : (raw)-> return raw
      datetime       : (raw)-> new Date(raw_Data).toDateString()
      issuetype      : (raw)=> return raw.name
      option         : (raw)-> return raw.value
      priority       : (raw)-> return raw.name
      progress       : (raw)-> return raw.progress
      project        : (raw)-> return raw.name
      status         : (raw)-> return raw.name
      string         : (raw)-> return raw
      timetracking   : (raw)-> return ''
      user           : (raw)-> return raw.name
      'comments-page': (raw)-> return ''            # ignored
      comments: (raw)->
        result = []
        for item in raw_Data.comments
          result.push item.body
        return result

    if parser[field_Type]
      return parser[field_Type](raw_Data)

    console.log "[get_Data_By_Type] no parser for #{field_Type}"
    console.log field_Type
    console.log raw_Data
    return null


module.exports = Map_Issues