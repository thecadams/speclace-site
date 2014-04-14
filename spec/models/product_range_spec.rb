require 'spec_helper'

describe ProductRange do
  it { should validate_presence_of :name }
  it { should have_many :products }

  it 'requires the name to be titleized' do
    range = ProductRange.create(name: 'oops forgot my capitalization')
    expect(range).not_to be_valid
    expect(range.errors[:name]).to include I18n.t('activerecord.errors.models.product_range.attributes.name.not_titleized')
  end

  describe '#slug' do
    let(:product_range) { ProductRange.new(name: 'Classic Range') }

    it 'returns a url-compatible slug' do
      expect(product_range.slug).to eq 'classic-range'
    end
  end
end
