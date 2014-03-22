module ProductHelper
  def delay_loaded_images(images, style)
    @result = ''
    images.each_with_index do |image, index|
      if index == 0
        @result += image_tag image.image(style), alt: image.alt, data: { loaded: true }
      else
        @result += image_tag nil, alt: image.alt, style: 'display:none', data: { src: image.image(style) }
      end
    end
    @result
  end

  def first_image_for(product, style)
    if product.images.any?
      image = product.images[0]
      image_tag image.image.url(style), alt: image.alt
    else
      image_tag '#'
    end
  end

  def price_for(price, currency)
    "#{number_to_currency price, unit: '$'} #{currency}"
  end

  def spinner
    content_tag :div, class: 'spinner', style: 'display:none' do
      content_tag :div, class: 'spinner-image' do
      end
    end
  end
end
