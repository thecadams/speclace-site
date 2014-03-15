jQuery ->
  if $('#image').length && $('#zoomwindow').length
    image = $('#image')

    image.mouseenter ->
      $('#zoomwindow').show()

    image.mouseleave ->
      $('#zoomwindow').hide()

    img = $('#image img')
    imgOffset = img.offset()
    imgPosition = img.position()
    imgLeft = imgOffset.left + imgPosition.left
    imgTop = imgOffset.top + imgPosition.top
    imgWidth = img[0].width
    imgHeight = img[0].height

    zoomWindowWidth = 300
    zoomWindowHeight = 250
    zoomedImg = $('#zoomwindow img')

    img.mousemove (event) ->
      zoomedImgWidth = zoomedImg[0].width
      zoomedImgHeight = zoomedImg[0].height

      x = ~~(event.pageX - imgLeft) * (zoomedImgWidth/imgWidth)
      y = ~~(event.pageY - imgTop) * (zoomedImgHeight/imgHeight)

      left = -1*x + zoomWindowWidth/2
      if left < -1 * (zoomedImgWidth - zoomWindowWidth)
        left = -1 * (zoomedImgWidth - zoomWindowWidth)
      if left > 0
        left = 0

      top = -1*y + zoomWindowHeight/2
      if top < -1 * (zoomedImgHeight - zoomWindowHeight)
        top = -1 * (zoomedImgHeight - zoomWindowHeight)
      if top > 0
        top = 0

      zoomedImg.css('left', left)
      zoomedImg.css('top', top)
