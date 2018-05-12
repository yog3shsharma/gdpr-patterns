Hugo_Proxy = require '../src/hugo-proxy'

describe  'Hugo-Proxy', ->
  hugo_Proxy = null
  options    = app : use : ()-> {}

  beforeEach ->
    hugo_Proxy = new Hugo_Proxy(options)

  it 'constructor',->
    using hugo_Proxy,->
      @.hugo_Server.assert_Is 'localhost'

    using new Hugo_Proxy(null),->
      @.options.assert_Is {}
      assert_Is_Undefined @.app

  it 'add_Routes', ->
    hugo_Proxy.add_Routes()