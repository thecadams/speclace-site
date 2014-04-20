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

  def price_for(price, currency=nil)
    number_to_currency(price, unit: '$') + (currency ? ' ' + currency : '')
  end

  def spinner
    content_tag :div, class: 'spinner', style: 'display:none' do
      content_tag :div, class: 'spinner-image' do
      end
    end
  end

  def filter_description(range, price_filter, colours)
    if colours.present?
      colour_portion = colours.map(&:name).map(&:titleize).to_sentence
    else
      colour_portion = range.present? || price_filter.present? ? '' : 'All'
    end

    price_filter_portion = " #{price_filter.label.downcase}" if price_filter.present?
    range_portion = range.present? ? " from the #{range.name.titleize}" : ''

    "#{colour_portion}#{colour_portion.present? ? ' ' : ''}Speclaces#{price_filter_portion}#{range_portion}"
  end
end
