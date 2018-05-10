describe 'canvas-test', ->
  sleep = (ms) ->
    new Promise (resolve) ->
      setTimeout resolve, ms

  it 'should work', ->
    console.log 'before await'
    await sleep 1000
    console.log 'after await'

#describe 'async-test', ->
#  it 'should work', async ()->
#    sleep = ()=>
#      new Promise (resolve)=>
#        setTimeout resolve,500
#
#    await sleep()
#    console.log 'here'