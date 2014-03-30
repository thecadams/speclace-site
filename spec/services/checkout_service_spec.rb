require 'spec_helper'

describe CheckoutService do
  describe '.update_session' do
    it 'does not update without params' do
      expect(CheckoutService.update_session({comments: 'foo'}, nil)).to eq({comments: 'foo'})
    end

    it 'updates comments' do
      expect(CheckoutService.update_session({comments: 'foo'}, {'comments' => 'bar'})).to eq({comments: 'bar'})
    end

    it 'updates delivery address' do
      expect(CheckoutService.update_session(
        {delivery_address: unmodified_address},
        as_params({delivery_address: modified_address})))
      .to eq({delivery_address: modified_address})
    end

    it 'updates billing address' do
      expect(CheckoutService.update_session(
        {billing_address: unmodified_address},
        as_params({billing_address: modified_address})))
      .to eq({billing_address: modified_address})
    end

    it 'updates everything' do
      expect(CheckoutService.update_session(
        {
          delivery_address: unmodified_address,
          billing_address: unmodified_address,
          comments: 'foo'
        },
        as_params({
          delivery_address: modified_address,
          billing_address: modified_address,
          comments: 'bar'
        })))
      .to eq(
        {
          delivery_address: modified_address,
          billing_address: modified_address,
          comments: 'bar'
        })
    end
  end

  describe '.save' do
    it 'saves the order and creates a payment' do
      session_id = 'session_id'
      product_1 = create_product(name: 'Product 1')
      product_2 = create_product(name: 'Product 2')
      session_cart = {product_1.id => 2, product_2.id => 3}
      session_order = {
        delivery_address: unmodified_address,
        billing_address: modified_address,
        comments: 'comments'
      }
      CheckoutService.save(session_id, session_order, session_cart)

      expect(Order.count).to eq 1
      order = Order.first
      expect(order.session_id).to eq session_id
      expect(order.products).to eq [product_1, product_1, product_2, product_2, product_2]
      expect(order.delivery_address.attributes).to eq Address.all[0].attributes
      expect(order.billing_address.attributes).to eq Address.all[1].attributes
      expect(order.comments).to eq 'comments'

      expect(Payment.count).to eq 1
      payment = Payment.first
      expect(payment.order).to eq Order.first
      expect(payment.complete).to be_false

      expect(order.payments.first).to eq payment
    end
  end

  describe '.create_payment_for' do
    it 'is a paypal response' do
      expect(CheckoutService.create_payment_for(Order.new, 'success_url', 'cancel_url')).to be_a Paypal::Express::Response
    end

    it 'has products and urls' do
      product = create_product(name: 'Product 1', price_in_aud: 21.95)
      response = CheckoutService.create_payment_for(Order.create!(products: [product, product]), 'success_url', 'cancel_url')
      expect(response.success_url).to eq 'success_url'
      expect(response.cancel_url).to eq 'cancel_url'
      expect(response.products.count).to eq 1
      expect(response.products[0].currency_code).to eq :AUD
      expect(response.products[0].description).to eq 'Product 1'
      expect(response.products[0].quantity).to eq 1
      expect(response.products[0].amount).to eq product.price_in_aud
    end
  end

  describe '.product_counts' do
    it 'returns a hash of counts' do
      expect(CheckoutService.product_counts([1,1,2,2,2])).to eq({1=>2, 2=>3})
    end
  end

  def unmodified_address
    {
      first_name: 'first',
      last_name: 'last',
      company: 'company',
      street_address_1: 'street address 1',
      street_address_2: 'street address 2',
      city: 'city',
      postcode: 'postcode',
      state: 'state',
      country: 'country',
      email: 'email',
      phone: 'phone'
    }
  end

  def modified_address
    {
      first_name: 'foo',
      last_name: 'bar',
      company: 'baz',
      street_address_1: 'quux',
      street_address_2: 'fop',
      city: 'xyzzy',
      postcode: 'corge',
      state: 'grault',
      country: 'garply',
      email: 'flob',
      phone: 'wubble'
    }
  end

  def as_params(params_hash)
    params_hash[:delivery_address] = params_hash[:delivery_address].stringify_keys if params_hash[:delivery_address]
    params_hash[:billing_address] = params_hash[:billing_address].stringify_keys if params_hash[:billing_address]
    params_hash = params_hash.stringify_keys
    params_hash
  end

  def create_product(attributes)
    product_range = ProductRange.create!(name: 'Default Range')
    image = Image.create!(image: File.new("#{Rails.root}/app/assets/images/logo.png"))
    Product.create!({product_range: product_range, price_in_aud: 1, image_1: image, image_2: image, image_3: image}.merge(attributes))
  end
end
