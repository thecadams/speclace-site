require 'spec_helper'

describe ProductBadge do
  it { should validate_presence_of :name }
  it { should belong_to :product_badge_css_class }

  it 'has soft delete' do
    ProductBadge.create!(name: 'badge', product_badge_css_class: ProductBadgeCssClass.create(name: 'red')).destroy
    expect(ProductBadge.with_deleted.count).to eq 1
    expect(ProductBadge.with_deleted.first.deleted_at).not_to be_nil
  end
end
