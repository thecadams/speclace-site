class CheckoutService
  class << self
    def order_from(session_id, session_order, session_cart)
      session_order ||= {}
      Order.new(
        session_id: session_id,
        products: products_from(session_cart),
        delivery_address: address_from(session_order[:delivery_address]),
        billing_address: address_from(session_order[:billing_address]),
        comments: session_order[:comments]
      ).tap(&:valid?)
    end

    def update_session(session_order, order_params)
      return session_order unless order_params

      session_order ||= {}
      session_order[:comments] = order_params['comments'] if order_params['comments']
      session_order[:same_addresses] = order_params['same_addresses'].to_bool if order_params['same_addresses']

      session_delivery_address = (session_order[:delivery_address] || {}).merge(order_params['delivery_address'].symbolize_keys) if order_params['delivery_address']
      if session_order[:same_addresses]
        session_billing_address = session_delivery_address
      else
        session_billing_address = (session_order[:billing_address] || {}).merge(order_params['billing_address'].symbolize_keys) if order_params['billing_address']
      end

      session_order[:delivery_address] = session_delivery_address if session_delivery_address.present?
      session_order[:billing_address] = session_billing_address if session_billing_address.present?
      session_order
    end

    def save!(session_id, session_order, session_cart)
      delivery_address = session_order ? Address.create!(session_order[:delivery_address]) : nil

      if session_order
        billing_address = session_order[:same_addresses] ?
          delivery_address :
          Address.create!(session_order[:billing_address])
      end

      Order.create!(
        session_id: session_id,
        products: products_from(session_cart),
        delivery_address: delivery_address,
        billing_address: billing_address,
        comments: session_order ? session_order[:comments] : nil
      )
    end

    def create_payment_for(order, success_url, cancel_url)
      items = []
      product_counts(order.products).each do |product, quantity|
        items << {
          name: product.name,
          sku: product.slug,
          price: '%.2f' % product.price_in_aud,
          currency: 'AUD',
          quantity: quantity
        }
      end

      total = order.products.inject(0) { |sum, product| sum += product.price_in_aud }

      paypal_payment = create_paypal_payment({
        intent: 'sale',
        payer: { payment_method: 'paypal' },
        redirect_urls: {
          return_url: success_url,
          cancel_url: cancel_url
        },
        transactions: [
          {
            item_list: { items: items },
            amount: {
              total: '%.2f' % total,
              currency: 'AUD'
            },
            description: 'Your Speclace order'
          }
        ]
      })

      Payment.create!(order: order, payment_id: paypal_payment.id, payment_object: paypal_payment.inspect)

      raise paypal_payment.error.inspect unless paypal_payment.create
      paypal_payment
    end

    def complete_payment(payment_id, payer_id)
      raise 'valid payment_id required' unless payment_id &&
        (payment = Payment.find_by_payment_id(payment_id))
      payment.update_attributes(complete: true)

      success = complete_paypal_payment(payment_id, payer_id)
      if success
        product_counts(payment.order.products).each do |product, quantity|
          product.update_attributes(stock_level: product.stock_level - quantity)
        end
      end
      success
    end

    def redirect_url_for(payment)
      payment.links.find{|v| v.method == "REDIRECT" }.try(:href)
    end

    def product_counts(products)
      counts_hash = products.group_by {|product_id| product_id }
      counts_hash.each {|product_id, products| counts_hash[product_id] = products.size }
      counts_hash
    end

    private

    def create_paypal_payment(attributes)
      PayPal::SDK::REST::Payment.new(attributes)
    end

    def complete_paypal_payment(payment_id, payer_id)
      PayPal::SDK::REST::Payment.find(payment_id).execute(payer_id: payer_id)
    end

    def products_from(session_cart)
      products = []
      (session_cart || {}).each do |product_id, quantity|
        product = Product.find(product_id)
        quantity.times do
          products << product
        end
      end
      products
    end

    def address_from(session_address)
      session_address ||= {}
      Address.new(
        first_name: session_address[:first_name],
        last_name: session_address[:last_name],
        company: session_address[:company],
        street_address_1: session_address[:street_address_1],
        street_address_2: session_address[:street_address_2],
        city: session_address[:city],
        postcode: session_address[:postcode],
        state: session_address[:state],
        country: session_address[:country],
        email: session_address[:email],
        phone: session_address[:phone]
      )
    end
  end
end
