jQuery ->
  if $('#image').length && $('#zoomwindow').length
    image = $('#image')
    zoomWindow = $('#zoomwindow')
    zoomIndicator = $('#zoomindicator')
    img = $('#image img')
    zoomedImg = $('#zoomwindow img')

    image.mouseenter ->
      zoomWindow.show()
      zoomIndicator.show()

    image.mouseleave ->
      zoomWindow.hide() 
      zoomIndicator.hide()

    imgLeft = ~~img.offset().left
    imgTop = ~~img.offset().top
    imgWidth = img[0].width
    imgHeight = img[0].height

    zoomWindowWidth = 300
    zoomWindowHeight = 250

    zoomIndicatorWidth = zoomIndicator.width()
    zoomIndicatorHeight = zoomIndicator.height()

    img.mousemove (event) ->
      updateZoomLocations(event)

    zoomIndicator.mousemove (event) ->
      updateZoomLocations(event)


    updateZoomLocations = (event) ->
      x = event.pageX - imgLeft
      y = event.pageY - imgTop - 102
      panZoomedImage(x, y)
      panZoomIndicator(x, y)


    panZoomedImage = (x, y) ->
      zoomedImgWidth = zoomedImg[0].width
      zoomedImgHeight = zoomedImg[0].height

      left = valueBoundedBy(
        -1*(x * (zoomedImgWidth/imgWidth)) + zoomWindowWidth/2,
        -1 * (zoomedImgWidth - zoomWindowWidth),
        0)

      top = valueBoundedBy(
        -1*(y * (zoomedImgHeight/imgHeight)) + zoomWindowHeight/2,
        -1 * (zoomedImgHeight - zoomWindowHeight),
        0)

      zoomedImg.css('left', left)
      zoomedImg.css('top', top)


    panZoomIndicator = (x, y) ->
      indicatorLeft = valueBoundedBy(
        x - zoomIndicatorWidth/2,
        0,
        imgWidth - zoomIndicatorWidth)

      indicatorTop = valueBoundedBy(
        y - zoomIndicatorHeight/2,
        0,
        imgHeight - zoomIndicatorHeight)

      zoomIndicator.css('left', indicatorLeft)
      zoomIndicator.css('top', indicatorTop)


    valueBoundedBy = (val, min, max) ->
      constrained = val
      constrained = min if constrained < min
      constrained = max if constrained > max
      constrained
