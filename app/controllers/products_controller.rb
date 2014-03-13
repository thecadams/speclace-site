class ProductsController < ApplicationController
  def index
    @products = Product.order(:priority, created_at: :desc).all
  end

  def show
    @product = Product.where(name: params[:slug].titleize).first!
  end
end
