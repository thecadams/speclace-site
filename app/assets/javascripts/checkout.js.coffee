jQuery ->
  $('#order_same_addresses').change -> same_addresses_checked()

  same_addresses_checked = ->
    address = $('#order_billing_address')
    requiredInputs = $('#order_billing_address input.required, #order_billing_address select.required')

    if $('#order_same_addresses').is(':checked')
      address.css 'display', 'none'
      requiredInputs.removeAttr('required')
      requiredInputs.removeAttr('aria-required')
    else
      address.css 'display', 'block'
      requiredInputs.attr('required', 'required')
      requiredInputs.attr('aria-required', 'true')

  same_addresses_checked()
