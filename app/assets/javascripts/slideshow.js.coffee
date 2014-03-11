jQuery ->
  if $('#slideshow').length
    intervalId = null

    startInterval = ->
      intervalId = setInterval(->
        $('#slideshow > div:first')
          .fadeOut(2000)
          .next()
          .fadeIn(2000)
          .end()
          .appendTo "#slideshow"
      , 2750)

    stopInterval = ->
      clearInterval intervalId

    jQuery ->
      $('#slideshow > div:gt(0)').hide()

      startInterval()

      $("#slideshow > div").mouseover ->
        stopInterval()

      $("#slideshow > div").mouseout ->
        startInterval()
