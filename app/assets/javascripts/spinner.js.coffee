jQuery ->
  if $('.spinner').length
    $.fn.startSpinning = ->
      $(this).each ->
        spinner = $(this).children(0)
        if !spinner.data('spin_id')
          spinner
            .css('background-position', '0px 0px')
            .data('x', 0)
            .data('spin_id', setInterval ->
              spinnerNextFrame(spinner)
            , 100)

    $.fn.stopSpinning = ->
      $(this).each ->
        spinner = $(this).children(0)
        if spinner.data('spin_id')
          clearInterval(spinner.data('spin_id'))
          spinner
            .removeData('spin_id')
            .css('background-position', '0 0')
            .data('x', 0)

    spinnerNextFrame = (spinner) ->
      spinner.data('x', spinner.data('x') - 26)
      if spinner.data('x') <= -312
        spinner.data('x', 0)
      spinner.css('background-position', '' + spinner.data('x') + 'px 0px')
