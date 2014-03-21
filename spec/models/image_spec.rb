require 'spec_helper'

describe Image do
  it { should belong_to :product }
  it { should validate_presence_of :product }

  it { should have_attached_file(:image) }
  it { should validate_attachment_presence(:image) }
  it { should validate_attachment_content_type(:image).
                allowing('image/png', 'image/gif').
                rejecting('text/plain', 'text/xml') }
  it { should validate_attachment_size(:image).
                less_than(2.megabytes) }

  it 'has soft delete' do
    Image.create!(product: Product.create!(name: 'Name', price_in_aud: 1, price_in_usd: 1), image: File.new("#{Rails.root}/app/assets/images/logo.png")).destroy
    expect(Image.with_deleted.count).to eq 1
    expect(Image.with_deleted.first.deleted_at).not_to be_nil
  end

  describe '#name' do
    it 'returns product' do
      expect(Image.new(alt: 'alt', product: Product.new(name: 'product')).name).to eq "Image for 'product': 'alt'"
    end
  end
end
