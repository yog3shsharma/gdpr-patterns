Exec_Code = require '../../src/dsl/exec-code'

describe 'dsl | exec-code',->

  exec_Code = null

  before ->
    exec_Code = new Exec_Code

  it 'constuctor', ->

  it 'coffee (2+2)', ->
    code = """a = =>  2+2;
              return a()"""
    exec_Code.coffee(code)
             .assert_Is 4

  it 'coffee - bad code',->
    code = "aaa&^*bbbb"
    using exec_Code.coffee(code), ->
      (@ instanceof Error).assert_Is_True()
      @.toString().assert_Is "[stdin]:1:5: error: unexpected ^\naaa&^*bbbb\n    ^"

  it 'coffee - runtime error',->
    code = "return an-error"
    using exec_Code.coffee(code), ->
      @.toString().assert_Is "ReferenceError: an is not defined"

  it 'coffee - this object',->
    code = "this.abc = 12; return this"
    using exec_Code.coffee(code), ->
      (@ instanceof Error).assert_Is_False()
      @.abc.assert_Is 12

  it 'coffee - get Jira issue data', ->
    code = "return @.map_Issues.issue('RISK-1')"
    using exec_Code.coffee(code), ->
      @.key.assert_Is 'RISK-1'
