require 'spec_helper'

describe CartController do
  let(:product) { FactoryGirl.create(:product) }
  describe '#update' do
    it 'creates a cart with two items of product one' do
      put :update, cart: {product.id => 2}
      expect(session[:cart]).to eq({product.id => 2})
    end

    it 'does not modify existing cart items' do
      product_2 = FactoryGirl.create(:product)
      session[:cart] = {product_2.id => 1}
      put :update, cart: {product.id => 2}
      expect(session[:cart]).to eq({product.id => 2, product_2.id => 1})
    end

    it 'redirects to cart' do
      put :update
      expect(response).to redirect_to cart_path
    end

    it 'supports checkout' do
      put :update, checkout: 'Checkout Securely'
      expect(response).to redirect_to checkout_path
    end

    it 'supports paypal' do
      CheckoutService.stub(:save) { :order }
      CheckoutService.stub(:create_payment_for)
      CheckoutService.stub(:redirect_url_for) { 'http://paypal.example.com/' }
      put :update, 'paypal.x' => 1, 'paypal.y' => 1
      expect(CheckoutService).to have_received(:save).with(request.session_options[:id], session[:order], {})
      expect(CheckoutService).to have_received(:create_payment_for).with(:order, checkout_success_url, checkout_cancel_url)
      expect(response).to redirect_to 'http://paypal.example.com/'
    end
  end

  describe '#add' do
    it 'increases stock count' do
      session[:cart] = {product.id => 2}
      put :add, cart: {product.id => 2}
      expect(session[:cart]).to eq({product.id => 4})
    end

    it 'creates new if no current cart' do
      put :add, cart: {product.id => 2}
      expect(session[:cart]).to eq({product.id => 2})
    end

    it 'redirects to cart' do
      put :add
      expect(response).to redirect_to cart_path
    end
  end

  describe '#get' do
    it 'looks up the products in the cart' do
      product_1 = FactoryGirl.create(:product, name: 'Product 1')
      product_2 = FactoryGirl.create(:product, name: 'Product 2')
      session[:cart] = {product_1.id => 5, product_2.id => 10}
      get :index
      expect(assigns[:cart]).to eq([[product_1, 5], [product_2, 10]])
    end
  end
end
