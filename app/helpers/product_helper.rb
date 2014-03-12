module ProductHelper
  def first_image_for(product)
    if product.images.any?
      image = product.images[0]
      image_tag image.url, alt: image.alt
    else
      image_tag '#'
    end
  end

  def price_for(price, currency)
    "#{number_to_currency price, unit: '$'} #{currency}"
  end
end
