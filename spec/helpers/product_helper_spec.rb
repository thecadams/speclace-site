require 'spec_helper'

describe ProductHelper do
  let(:image_file) { File.new("#{Rails.root}/app/assets/images/logo.png") }
  describe '#first_image_for' do
    let(:image1) { Image.new(image: image_file, alt: 'image1') }
    let(:image2) { Image.new(image: image_file, alt: 'image2') }

    context 'when there are images' do
      let(:product) { double(images: [image1, image2]) }

      it 'returns url of the first image' do
        img_url = image_url(:medium, 'logo.png')
        img_tag = image_tag(img_url, alt: image1.alt)
        expect(helper.first_image_for(product, :medium)).to eq img_tag
      end
    end

    context 'when there are no images' do
      let(:product) { double(images: []) }

      it 'returns #' do
        expect(helper.first_image_for(product, :medium)).to eq image_tag '#'
      end
    end
  end

  describe '#price_for' do
    it 'shows a price' do
      expect(helper.price_for(2.34, 'AUD')).to eq '$2.34 AUD'
    end

    it 'shows 2 decimal places' do
      expect(helper.price_for(2)).to eq '$2.00'
      expect(helper.price_for(2.04091)).to eq '$2.04'
    end

    it 'shows currency' do
      expect(helper.price_for(2, 'USD')).to eq '$2.00 USD'
    end
  end

  def image_url(style, name)
    "/system/images/images//#{style}/#{name}?#{Time.now.to_i}"
  end
end
