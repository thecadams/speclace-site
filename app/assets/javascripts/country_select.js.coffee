$ ->
  country_select = (address) ->
    $('select#order_' + address + '_country').change ->
      select_wrapper = $('#order_' + address + '_state_wrapper')

      $('select', select_wrapper).attr('disabled', true)

      country_code = $(this).val()
      name = $(this).attr('name')

      url = "/checkout/subregion_options?parent_region=#{country_code}&address=#{address}"
      select_wrapper.load(url)

  country_select 'billing_address'
  country_select 'delivery_address'
