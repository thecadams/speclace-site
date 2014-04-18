require 'spec_helper'

describe ProductColour do
  it { should validate_presence_of :name }
  it { should have_and_belong_to_many :products }

  it 'requires the name to be titleized' do
    colour = ProductColour.create(name: 'oops forgot my capitalization')
    expect(colour).not_to be_valid
    expect(colour.errors[:name]).to include I18n.t('activerecord.errors.models.product_colour.attributes.name.not_titleized')
  end

  describe '#slug' do
    let(:product_colour) { ProductColour.new(name: 'Blue Colour') }

    it 'returns a url-compatible slug' do
      expect(product_colour.slug).to eq 'blue-colour'
    end
  end
end
