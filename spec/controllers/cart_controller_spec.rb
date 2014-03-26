require 'spec_helper'

describe CartController do
  let(:product_range) { ProductRange.create!(name: 'Range') }
  let(:image) { Image.create!(image: File.new("#{Rails.root}/app/assets/images/logo.png")) }
  let(:product) { Product.create!(name: 'Name', price_in_aud: 1, image_1: image, image_2: image, image_3: image, product_range: product_range) }
  describe '#update' do
    it 'creates a cart with two items of product one' do
      put :update, cart: {product.id => 2}
      expect(session[:cart]).to eq({product.id => 2})
      response.should redirect_to cart_path
    end

    it 'does not modify existing cart items' do
      product_2 = Product.create!(name: 'Name', price_in_aud: 1, image_1: image, image_2: image, image_3: image, product_range: product_range)
      session[:cart] = {product_2.id => 1}
      put :update, cart: {product.id => 2}
      expect(session[:cart]).to eq({product.id => 2, product_2.id => 1})
    end

    it 'allows remove' do
      session[:cart] = {product.id => 1}
      put :update, cart: {product.id => 1}, remove: {product.id => 'Remove'}
      expect(session[:cart]).to eq({})
    end

    it 'updates cart during checkout' do
      put :update, cart: {product.id => 1}, checkout: 'Checkout Securely'
      expect(session[:cart]).to eq({product.id => 1})
      response.should redirect_to checkout_cart_path
    end
  end

  describe '#add' do
    it 'increases stock count' do
      session[:cart] = {product.id => 2}
      put :add, cart: {product.id => 2}
      expect(session[:cart]).to eq({product.id => 4})
      response.should redirect_to cart_path
    end

    it 'creates new if no current cart' do
      put :add, cart: {product.id => 2}
      expect(session[:cart]).to eq({product.id => 2})
      response.should redirect_to cart_path
    end
  end

  describe '#get' do
    it 'looks up the products in the cart' do
      product_1 = create_product(name: 'Product 1')
      product_2 = create_product(name: 'Product 2')
      session[:cart] = {product_1.id => 5, product_2.id => 10}
      get :index
      expect(assigns[:cart]).to eq([[product_1, 5], [product_2, 10]])
    end
  end

  def create_product(attributes)
    product_range = ProductRange.create!(name: 'Default Range')
    image = Image.create!(image: File.new("#{Rails.root}/app/assets/images/logo.png"))
    Product.create!({product_range: product_range, price_in_aud: 1, image_1: image, image_2: image, image_3: image}.merge(attributes))
  end
end
