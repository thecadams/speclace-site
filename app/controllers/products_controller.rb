class ProductsController < ApplicationController
  before_filter :load_ranges, :load_price_filters, :load_colours

  def index
    params[:range] = nil if params[:range] == 'on'
    params[:price] = nil if params[:price] == 'on'

    @range_name = params[:range].try(:titleize)
    @range = ProductRange.where(name: @range_name).first! if @range_name
    @colours = params[:colours].map {|colour| ProductColour.where(name: colour.titleize).first!} if params[:colours]
    @price_filter = @price_filters.select{|f| f.to_s == params[:price] }.first if params[:price]
    @products = filtered_products
  end

  def show
    @product = Product.where(name: params[:slug].titleize).first!
  end

  private

  def load_ranges
    @product_ranges = ProductRange.all.to_a
  end

  def load_price_filters
    @price_filters = [
        PriceFilter.new(nil,nil,'Any price'),
        PriceFilter.new(nil,30,'Less than $30'),
        PriceFilter.new(30,50,'$30 to $50'),
        PriceFilter.new(50,nil,'$50 and above')
    ]
  end

  def load_colours
    @product_colours = ProductColour.all.to_a
  end

  def filtered_products
    where = []
    where << "product_range_id='#{@range.id}'" if @range
    where << "price_in_aud > '#{@price_filter.price_from}'" if @price_filter.try(:price_from)
    where << "price_in_aud < '#{@price_filter.price_to}'" if @price_filter.try(:price_to)
    where << "product_colours.id in (#{@colours.map(&:id).join(',')})" if @colours

    product_model = has_colours? ? Product.joins(:product_colours) : Product

    products_relation = where.present? ?
        product_model.where(where.join(' and ')) :
        product_model.all

    products_relation.order(:priority, created_at: :desc).to_a
  end

  def has_colours?
    !!@colours
  end
end
