class CheckoutService
  class << self
    def order_from(session_id, session_order)
      session_order ||= {}
      Order.new(
        session_id: session_id,
        delivery_address: address_from(session_order[:delivery_address]),
        billing_address: address_from(session_order[:billing_address]),
        comments: session_order[:comments]
      )
    end

    def update_session(session_order, order_params)
      return session_order unless order_params
      session_order[:comments] = order_params['comments'] if order_params['comments']
      session_order[:delivery_address] = session_order[:delivery_address].merge(order_params['delivery_address'].symbolize_keys) if order_params['delivery_address']
      session_order[:billing_address] = session_order[:billing_address].merge(order_params['billing_address'].symbolize_keys) if order_params['billing_address']
      session_order
    end

    def save(session_id, session_order, session_cart)
      order = Order.create!(
        session_id: session_id,
        products: products_from(session_cart),
        delivery_address: Address.create!(session_order[:delivery_address]),
        billing_address: Address.create!(session_order[:billing_address]),
        comments: session_order[:comments]
      )

      Payment.create!(order: order)
    end

    def create_payment_for(order, success_url, cancel_url)
      request = Paypal::Express::Request.new
      payment = Paypal::SDK::Rest::Payment.new

      products = []
      product_counts(order.products).each do |product, quantity|
        products << Paypal::Payment::Request.new(
          currency_code: :AUD,
          description: product.name,
          quantity: quantity,
          amount: product.price_in_aud
        )
      end

      request.setup(
        products,
        success_url,
        cancel_url
      )
    end

    def product_counts(products)
      counts_hash = products.group_by {|product_id| product_id }
      counts_hash.each {|product_id, products| counts_hash[product_id] = products.size }
      counts_hash
    end

    private

    def products_from(session_cart)
      products = []
      session_cart.each do |product_id, quantity|
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
