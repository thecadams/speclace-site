require 'spec_helper'

describe Product do
  it { should belong_to :product_badge }
  it { should belong_to :product_range }
  it { should validate_presence_of :name }
  it { should validate_presence_of :price_in_aud }
  it { should validate_presence_of :price_in_usd }
  it { should validate_presence_of :priority }
  it { should validate_presence_of :stock_level }
  it { should validate_presence_of :image_1 }
  it { should validate_presence_of :image_2 }
  it { should validate_presence_of :image_3 }

  let(:image) { Image.create!(image: File.new("#{Rails.root}/app/assets/images/logo.png")) }

  it 'has soft delete' do
    Product.create!(name: 'Name', price_in_aud: 0, price_in_usd: 0, image_1: image, image_2: image, image_3: image).destroy
    expect(Product.with_deleted.count).to eq 1
    expect(Product.with_deleted.first.deleted_at).not_to be_nil
  end

  it 'does not allow dashes in the name' do
    product = Product.create(name: 'name-with-dashes')
    expect(product).not_to be_valid
    expect(product.errors[:name]).to include I18n.t('activerecord.errors.models.product.attributes.name.has_dashes')
  end

  it 'requires the name to be titleized' do
    product = Product.create(name: 'oops forgot my capitalization')
    expect(product).not_to be_valid
    expect(product.errors[:name]).to include I18n.t('activerecord.errors.models.product.attributes.name.not_titleized')
  end

  describe '#slug' do
    let(:product) { Product.new(name: 'A Beautiful Speclace') }

    it 'returns a url-compatible slug' do
      expect(product.slug).to eq 'a-beautiful-speclace'
    end
  end

  describe '#images' do
    let(:image1) { Image.new(alt: 'image1') }
    let(:image2) { Image.new(alt: 'image2') }
    let(:image3) { Image.new(alt: 'image3') }
    let(:image4) { Image.new(alt: 'image4') }

    it 'is all images' do
      expect(
        Product.new(image_1: image1, image_2: image2, image_3: image3, image_4: image4).images
      ).to eq [image1, image2, image3, image4]
    end

    it 'returns 3 images if no fourth' do
      expect(
        Product.new(image_1: image1, image_2: image2, image_3: image3).images
      ).to eq [image1, image2, image3]
    end
  end
end
