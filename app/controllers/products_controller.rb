class ProductsController < ApplicationController
  def index
    @products = Product.order(:priority, created_at: :desc).all
  end
end
