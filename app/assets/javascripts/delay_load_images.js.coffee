jQuery ->
  if $('.thumbnails').length
    $('.thumbnails a').click (event) ->
      console.log 'hi'
      index = $(event.target).index()

      showImage($('#image img'), index)
      showImage($('#zoomwindow img'), index)

    showImage = (images, index) ->
      images.hide()

      image = $(images[index])
      if !image.data('loaded')
        image.attr('src', image.data('src'))
        image.data 'loaded', true
      image.show()
