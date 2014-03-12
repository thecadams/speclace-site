require 'spec_helper'

describe Image do
  it { should belong_to :product }
  it { should validate_presence_of :url }

  it 'has soft delete' do
    Image.create!(url: 'http://example.com/image1.jpg').destroy
    expect(Image.with_deleted.count).to eq 1
    expect(Image.with_deleted.first.deleted_at).not_to be_nil
  end
end
