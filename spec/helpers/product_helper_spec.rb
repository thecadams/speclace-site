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

  describe '#filter_description' do
    let(:range) { nil }
    let(:price_filter) { nil }
    let(:colours) { nil }

    subject(:title) { helper.filter_description(range, price_filter, colours) }

    context 'when unfiltered' do
      it 'has nice default' do
        expect(subject).to eq 'All Speclaces'
      end
    end

    context 'when no colours are selected' do
      let(:colours) { [] }
      it 'has nice default' do
        expect(subject).to eq 'All Speclaces'
      end
    end

    context 'when 1 colour is selected' do
      let(:colours) { [ProductColour.new(name: 'blue')] }
      it 'describes the colours' do
        expect(subject).to eq 'Blue Speclaces'
      end
    end

    context 'when 2 colours are selected' do
      let(:colours) { [ProductColour.new(name: 'blue'), ProductColour.new(name: 'green')] }
      it 'describes the colours' do
        expect(subject).to eq 'Blue and Green Speclaces'
      end
    end

    context 'when 3 colours are selected' do
      let(:colours) { [ProductColour.new(name: 'blue'), ProductColour.new(name: 'green'), ProductColour.new(name: 'red')] }
      it 'describes the colours' do
        expect(subject).to eq 'Blue, Green, and Red Speclaces'
      end
    end

    context 'when a range is selected' do
      let(:range) { ProductRange.new(name: 'classic-range') }
      it 'describes the range' do
        expect(subject).to eq 'Speclaces from the Classic Range'
      end
    end

    context 'when a price range is selected' do
      let(:price_filter) { PriceFilter.new(nil,nil,'Less than $30') }
      it 'describes the price filter' do
        expect(subject).to eq 'Speclaces less than $30'
      end
    end

    context 'when everything is selected' do
      let(:range) { ProductRange.new(name: 'classic-range') }
      let(:price_filter) { PriceFilter.new(30,50,'$30 to $50') }
      let(:colours) { [ProductColour.new(name: 'blue'), ProductColour.new(name: 'green'), ProductColour.new(name: 'red')] }
      it 'describes the price filter' do
        expect(subject).to eq 'Blue, Green, and Red Speclaces $30 to $50 from the Classic Range'
      end
    end
  end

  def image_url(style, name)
    "/system/images/images//#{style}/#{name}?#{Time.now.to_i}"
  end
end
