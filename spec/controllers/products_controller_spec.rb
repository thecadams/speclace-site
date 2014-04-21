require 'spec_helper'

describe ProductsController do
  describe '#index' do
    it 'shows all products' do
      product = FactoryGirl.create :product
      get :index
      expect(assigns(:products)).to eq [product]
    end

    it 'shows products matching range' do
      included_range = FactoryGirl.create :product_range
      included_product = FactoryGirl.create :product, product_range: included_range

      another_range = FactoryGirl.create :product_range, name: 'Another Range'
      FactoryGirl.create(:product, name: 'Excluded', product_range: another_range)

      expect(Product.count).to eq 2

      get :index, range: included_range.slug
      expect(assigns(:products)).to eq [included_product]
    end

    it 'shows products matching price range' do
      included_product = FactoryGirl.create :product, price_in_aud: 35
      FactoryGirl.create :product, name: 'Excluded', price_in_aud: 5

      expect(Product.count).to eq 2

      get :index, price: PriceFilter.new(30,50,'$30 to $50').to_s
      expect(assigns(:products)).to eq [included_product]
    end

    it 'shows products matching colour' do
      included_colour = FactoryGirl.create :product_colour
      included_product = FactoryGirl.create :product, product_colours: [included_colour]

      another_colour = FactoryGirl.create :product_colour, name: 'Blue'
      FactoryGirl.create(:product, name: 'Excluded', product_colours: [another_colour])

      expect(Product.count).to eq 2

      get :index, colours: [included_colour.slug]
      expect(assigns(:products)).to eq [included_product]
    end

    it 'shows products matching multiple' do
      included_range = FactoryGirl.create :product_range
      included_colour = FactoryGirl.create :product_colour
      included_product = FactoryGirl.create :product, price_in_aud: 35, product_range: included_range, product_colours: [included_colour]

      FactoryGirl.create :product, name: 'Excluded Price', price_in_aud: 5

      another_colour = FactoryGirl.create :product_colour, name: 'Blue'
      FactoryGirl.create(:product, name: 'Excluded Colour', product_colours: [another_colour])

      another_range = FactoryGirl.create :product_range, name: 'Another Range'
      FactoryGirl.create(:product, name: 'Excluded Range', product_range: another_range)

      expect(Product.count).to eq 4

      get :index, range: included_range.slug, price: PriceFilter.new(30,50,'$30 to $50').to_s, colours: [included_colour.slug]
      expect(assigns(:products)).to eq [included_product]
    end
  end
end