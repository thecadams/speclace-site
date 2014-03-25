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
  it { should validate_presence_of :product_range }

  let(:image) { Image.create!(image: File.new("#{Rails.root}/app/assets/images/logo.png")) }

  it 'has soft delete' do
    create_product(name: 'Name').destroy
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

  describe '#recommendations' do
    it 'returns manually selected recommendations' do
      recommendations = []
      5.times { recommendations << create_product(name: 'Recommendation', stock_level: 1) }
      product = Product.new(
        recommendation_1: recommendations[0],
        recommendation_2: recommendations[1],
        recommendation_3: recommendations[2],
        recommendation_4: recommendations[3],
        recommendation_5: recommendations[4]
      )
      expect(product.recommendations).to eq recommendations
    end

    it 'does not hit the database when all recommendations are selected' do
      recommendations = []
      5.times { recommendations << create_product(name: 'Recommendation', stock_level: 1) }
      product = Product.new(
        recommendation_1: recommendations[0],
        recommendation_2: recommendations[1],
        recommendation_3: recommendations[2],
        recommendation_4: recommendations[3],
        recommendation_5: recommendations[4]
      )
      Product.stub(:where)
      product.recommendations
      expect(Product).not_to have_received(:where)
    end

    it 'chooses recommendations from the same range ordered by descending stock level, then other ranges alphabetically' do
      current_range = ProductRange.new(name: 'Current Range')
      first_range = ProductRange.new(name: 'First Range')
      second_range = ProductRange.new(name: 'Second Range')

      recommendations = [
        create_product(name: 'Another Product From Current Range', product_range: current_range, stock_level: 2),
        create_product(name: 'Low Stock Product From Current Range', product_range: current_range, stock_level: 1),
        create_product(name: 'High Stock Product From First Range', product_range: first_range, stock_level: 10),
        create_product(name: 'Low Stock Product From First Range', product_range: first_range, stock_level: 5),
        create_product(name: 'Product From Second Range', product_range: second_range, stock_level: 1)
      ]
      product = create_product(name: 'Product', product_range: current_range)
      expect(product.recommendations).to eq recommendations
    end

    it 'does not return out of stock products in recommendations' do
      current_range = ProductRange.new(name: 'Current Range')
      out_of_stock_recommendation = create_product(name: 'Out Of Stock', product_range: current_range, stock_level: 0)

      product = Product.new(product_range: current_range)
      expect(product.recommendations).not_to include out_of_stock_recommendation
    end

    it 'returns a mix' do
      r1 = create_product(name: 'Recommendation 1')
      auto_1 = create_product(name: 'Automatic Recommendation 1')
      r3 = create_product(name: 'Recommendation 3')
      auto_2 = create_product(name: 'Automatic Recommendation 2')
      r5 = create_product(name: 'Recommendation 5')

      product = create_product(name: 'Example', recommendation_1: r1, recommendation_3: r3, recommendation_5: r5)
      expect(product.recommendations).to eq [r1, auto_1, r3, auto_2, r5]
    end

    it 'does not suggest the current product' do
      product = create_product(name: 'Another Speclace')
      expect(product.recommendations).not_to include product
    end

    it 'does not return nil items' do
      expect(create_product(name: 'Another Speclace').recommendations.select {|r| r.nil?}).to be_empty
    end
  end

  def create_product(attributes)
    product_range = ProductRange.create!(name: 'Default Range')
    image = Image.create!(image: File.new("#{Rails.root}/app/assets/images/logo.png"))
    Product.create!({product_range: product_range, price_in_aud: 1, price_in_usd: 1, image_1: image, image_2: image, image_3: image, stock_level: 1}.merge(attributes))
  end
end
