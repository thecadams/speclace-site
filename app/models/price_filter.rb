class PriceFilter
  attr_accessor :price_from, :price_to, :label

  def initialize(price_from, price_to, label)
    @price_from = price_from
    @price_to = price_to
    @label = label
  end

  def to_s
    "#{price_from}_to_#{price_to}"
  end
end