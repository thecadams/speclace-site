require 'spec_helper'

describe CheckoutController do
  before { init_session }

  describe '#index' do
    it 'copes with uninitialized session' do
      session.delete :order
      expect {get :index}.not_to raise_error
    end

    it 'builds an order from session' do
      get :index
      expect(assigns(:order).attributes).to eq populated_order.attributes
    end
  end

  describe '#update' do
    it 'updates the session' do
      post :update, order: {delivery_address: {first_name: 'something else'}}
      expect(session[:order][:delivery_address][:first_name]).to eq 'something else'
    end

    it 'redirects to the confirm page' do
      post :update
      expect(response).to redirect_to confirm_checkout_path
    end
  end

  describe '#confirm' do
    it 'copes with uninitialized session' do
      session.delete :order
      expect {get :index}.not_to raise_error
    end

    it 'builds an order from session' do
      get :confirm
      expect(assigns(:order).attributes).to eq populated_order.attributes
    end
  end

  describe '#confirmed' do
    it 'saves the order and a payment record' do
      product = create_product(name: 'Example')
      session[:cart] = {product.id => 1}
      post :confirmed
      expect(Order.count).to eq 1
      expect(Address.count).to eq 2
      expect(Order.first.session_id).to eq request.session_options[:id]
      expect(Order.products).to eq [product]

      expect(Payment.count).to eq 1
      expect(Payment.first.order).to eq Order.first
    end

    it 'prepares a paypal payment and redirects' do
      post :confirmed
      expect(assigns(:payment_request)).not_to be_nil
    end

    it 'issues a redirect to paypal' do
      post :confirmed
      expect(response).to redirect_to 'paypal'
    end
  end

  describe '#success' do
    it 'checks paypal parameters are present'
    it 'looks up the order based on most recent and session id or token, not sure which yet'
    it 'is ok if no order can be found'
    it 'updates the payment record'
    it 'removes the order from the session'
    it 'updates stock levels'
  end

  describe '#cancel' do
    it 'checks paypal parameters are present'
    it 'sets a flash'
    it 'redirects to the cart'
  end

  def init_session
    session[:order] = {}
    session[:order][:delivery_address] = {}
    session[:order][:delivery_address][:first_name] = 'first'
    session[:order][:delivery_address][:last_name] = 'last'
    session[:order][:delivery_address][:company] = 'company'
    session[:order][:delivery_address][:street_address_1] = 'street address 1'
    session[:order][:delivery_address][:street_address_2] = 'street address 2'
    session[:order][:delivery_address][:city] = 'city'
    session[:order][:delivery_address][:postcode] = '3000'
    session[:order][:delivery_address][:state] = 'state'
    session[:order][:delivery_address][:country] = 'country'
    session[:order][:delivery_address][:email] = 'email'
    session[:order][:delivery_address][:phone] = 'phone'
    session[:order][:billing_address] = {}
    session[:order][:billing_address][:first_name] = 'first'
    session[:order][:billing_address][:last_name] = 'last'
    session[:order][:billing_address][:company] = 'company'
    session[:order][:billing_address][:street_address_1] = 'street address 1'
    session[:order][:billing_address][:street_address_2] = 'street address 2'
    session[:order][:billing_address][:city] = 'city'
    session[:order][:billing_address][:postcode] = '3000'
    session[:order][:billing_address][:state] = 'state'
    session[:order][:billing_address][:country] = 'country'
    session[:order][:billing_address][:email] = 'email'
    session[:order][:billing_address][:phone] = 'phone'
    session[:order][:comments] = 'comments'
  end

  def populated_order
    Order.new(
      session_id: request.session_options[:id],
      delivery_address: populated_address,
      billing_address: populated_address,
      comments: 'comments'
    )
  end

  def populated_address
    Address.new(
      first_name: 'first',
      last_name: 'last',
      company: 'company',
      street_address_1: 'street address 1',
      street_address_2: 'street address 2',
      city: 'city',
      postcode: '3000',
      state: 'state',
      country: 'country',
      email: 'email',
      phone: 'phone'
    )
  end

  def create_product(attributes)
    product_range = ProductRange.create!(name: 'Default Range')
    image = Image.create!(image: File.new("#{Rails.root}/app/assets/images/logo.png"))
    Product.create!({product_range: product_range, price_in_aud: 1, image_1: image, image_2: image, image_3: image}.merge(attributes))
  end
end
