Supertest = require '../src/_test-utils/Supertest'
cherrio   = require 'cheerio'

describe 'hugo-proxy | supertest | Debug', ->
  supertest = null

  before ->
    supertest = new Supertest()

  request = (path, callback)->
    supertest.request "#{path}", (data)->
      $ = cherrio.load(data)
      callback $

  it '/', ->
    request '/',($)->
      $('title').html().assert_Is 'home page'

  it '/admin', ->
    request '/admin/',($)->
      $('title').html().assert_Is 'Admin pages'

  it '/an-404-error', ->
    request '/an-404-error/',($)->
      $.html().assert_Contains 'Redirecting to /404?url=/an-404-error/'

  it '/404?url=abc', ->
    request '/404?url=abc',($)->
      $.html().assert_Contains '404 on <a href="abc">abc</a>'

  it '/throw-error', ->
    request '/throw-error',($)->
      $.html().assert_Contains "Error: an error for you"
              .assert_Contains "jira-proxy/src/hugo-proxy"