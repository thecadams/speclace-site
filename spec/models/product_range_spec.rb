require 'spec_helper'

describe ProductRange do
  it { should validate_presence_of :name }

  it 'requires the name to be titleized' do
    range = ProductRange.create(name: 'oops forgot my capitalization')
    expect(range).not_to be_valid
    expect(range.errors[:name]).to include I18n.t('activerecord.errors.models.product_range.attributes.name.not_titleized')
  end
end
