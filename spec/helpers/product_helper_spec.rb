require 'spec_helper'

describe ProductHelper do
  describe '#first_image_for' do
    let(:image1) { double(url: 'http://example.com/image1.jpg', alt: 'image1') }
    let(:image2) { double(url: 'http://example.com/image2.jpg', alt: 'image2') }

    context 'when there are images' do
      let(:product) { double(images: [image1, image2]) }

      it 'returns url of the first image' do
        expect(helper.first_image_for(product)).to eq image_tag image1.url, alt: image1.alt
      end
    end

    context 'when there are no images' do
      let(:product) { double(images: []) }

      it 'returns #' do
        expect(helper.first_image_for(product)).to eq image_tag '#'
      end
    end
  end

  describe '#price_for' do
    it 'shows a price' do
      expect(helper.price_for(2.34, 'AUD')).to eq '$2.34 AUD'
    end

    it 'shows 2 decimal places' do
      expect(helper.price_for(2, 'AUD')).to eq '$2.00 AUD'
      expect(helper.price_for(2.04091, 'AUD')).to eq '$2.04 AUD'
    end

    it 'shows currency' do
      expect(helper.price_for(2, 'USD')).to eq '$2.00 USD'
    end
  end
end
