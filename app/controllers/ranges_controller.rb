class RangesController < ApplicationController
  def show
    @range = ProductRange.where(name: params[:name].titleize).first!
    @products = @range.products
  end
end
