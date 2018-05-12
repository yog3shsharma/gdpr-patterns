describe 'canvas-test', ->
  sleep = (ms) ->
    new Promise (resolve) ->
      setTimeout resolve, ms

  it 'should work', ->
    await sleep 25