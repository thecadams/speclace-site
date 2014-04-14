class RangesController < ApplicationController
  before_filter :load_ranges

  def show
    @range = ProductRange.where(name: params[:name].titleize).first!
    @products = @range.products
  end

  private

  def load_ranges
    @product_ranges = ProductRange.all.to_a
  end
end
