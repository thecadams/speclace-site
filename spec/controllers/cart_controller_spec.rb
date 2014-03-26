require 'spec_helper'

describe CartController do
  describe '#update' do
    it 'creates a cart with two items of product one' do
      put :update, cart: {1 => 2}
      expect(session[:cart]).to eq({1 => 2})
      response.should redirect_to cart_path
    end

    it 'does not modify existing cart items' do
      session[:cart] = {2 => 1}
      put :update, cart: {1 => 2}
      expect(session[:cart]).to eq({1 => 2, 2 => 1})
    end
  end

  describe '#add' do
    it 'increases stock count' do
      session[:cart] = {1 => 2}
      put :add, cart: {1 => 2}
      expect(session[:cart]).to eq({1 => 4})
      response.should redirect_to cart_path
    end

    it 'creates new if no current cart' do
      put :add, cart: {1 => 2}
      expect(session[:cart]).to eq({1 => 2})
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
    Product.create!({product_range: product_range, price_in_aud: 1, price_in_usd: 1, image_1: image, image_2: image, image_3: image}.merge(attributes))
  end
end
