require 'spec_helper'

describe Image do
  it { should have_attached_file(:image) }
  it { should validate_attachment_presence(:image) }
  it { should validate_attachment_content_type(:image).
                allowing('image/png', 'image/gif', 'image/jpg', 'image/jpeg').
                rejecting('text/plain', 'text/xml') }
  it { should validate_attachment_size(:image).
                less_than(2.megabytes) }

  it 'has soft delete' do
    Image.create!(image: File.new("#{Rails.root}/app/assets/images/logo.png")).destroy
    expect(Image.with_deleted.count).to eq 1
    expect(Image.with_deleted.first.deleted_at).not_to be_nil
  end

  describe '#name' do
    it 'returns alt' do
      expect(Image.new(alt: 'alt').name).to eq "Image: 'alt'"
    end
  end
end
