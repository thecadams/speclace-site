jQuery ->
  $('#order_same_addresses').change ->
    $('#order_billing_address').css 'display', if this.checked then 'none' else 'block'
