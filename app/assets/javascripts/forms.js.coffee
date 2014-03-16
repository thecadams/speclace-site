jQuery ->
  $('textarea:visible').autosize()
  $('.trigger-autosize').click ->
    $('textarea').autosize()
