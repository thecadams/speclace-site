class PriceFilter
  attr_accessor :price_from, :price_to, :label

  def initialize(price_from, price_to, label)
    @price_from = price_from
    @price_to = price_to
    @label = label
  end
end