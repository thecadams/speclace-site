class CartController < ApplicationController
  before_filter :initialize_cart

  def update
    cart_stock_counts.each { |k, v| session[:cart][k] = v }
    redirect_to cart_path
  end

  def add
    cart_stock_counts.each { |k, v| session[:cart][k] = (session[:cart][k] || 0) + v }
    redirect_to cart_path
  end

  def index
    cart_products = {}
    session[:cart].each { |product_id, quantity| cart_products[Product.find(product_id)] = quantity }
    @cart = cart_products.sort_by { |product, _| product.name }
    @subtotal = cart_products.map { |product, quantity| product.price_in_aud * quantity }.sum
    @shipping = 3.95
    @total = @subtotal + @shipping
  end

  private

  def initialize_cart
    session[:cart] = {} unless session[:cart]
  end

  def cart_stock_counts
    cart = params[:cart]
    cart.each { |k, v| cart[k] = v.to_i }
  end
end
