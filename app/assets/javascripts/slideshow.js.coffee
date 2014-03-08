jQuery ->
  if $('#slideshow').length
    intervalId = null

    startInterval = ->
      intervalId = setInterval(->
        $('#slideshow > div:first')
          .fadeOut(1000)
          .next()
          .fadeIn(1000)
          .end()
          .appendTo "#slideshow"
      , 3000)

    stopInterval = ->
      clearInterval intervalId

    jQuery ->
      $('#slideshow > div:gt(0)').hide()

      startInterval()

      $("#slideshow > div").mouseover ->
        stopInterval()

      $("#slideshow > div").mouseout ->
        startInterval()
