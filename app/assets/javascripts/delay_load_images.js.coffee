jQuery ->
  if $('.thumbnails').length
    $('.thumbnails a').click (event) ->
      index = $(event.target).parent().index()

      showImage($('#image img'), $('#image .spinner'), index)
      showImage($('#zoomwindow img'), $('#zoomwindow .spinner'), index)

    showImage = (images, spinner, index) ->
      images.hide()
      image = $(images[index])
      showInProgressSpinner(image, spinner)

      if notYetLoaded(image)
        image.attr('src', image.data('src'))
        image.data 'loading', true
        spinner.startSpinning().show()

        image.load ->
          image.unbind 'load'
          image.data('loading', false)
          image.data('loaded', true)
          spinner.hide().stopSpinning()

      image.show()

    notYetLoaded = (image) ->
      !image.data('loading') && !image.data('loaded')

    showInProgressSpinner = (image, spinner) ->
      if image.data('loading')
        spinner.startSpinning().show()
      else
        spinner.hide().stopSpinning()
