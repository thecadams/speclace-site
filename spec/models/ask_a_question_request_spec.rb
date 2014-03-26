require 'spec_helper'

describe AskAQuestionRequest do
  it { should belong_to :product }
  it { should validate_presence_of :product_id }
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :question }

  let(:product_range) { ProductRange.create!(name: 'Range') }
  let(:image) { Image.create!(image: File.new("#{Rails.root}/app/assets/images/logo.png")) }
  let(:product) { Product.create!(name: 'Name', price_in_aud: 1, image_1: image, image_2: image, image_3: image, product_range: product_range) }

  it 'has soft delete' do
    AskAQuestionRequest.create!(name: 'name', email: 'user@example.com', question: 'test', product: product).destroy
    expect(AskAQuestionRequest.with_deleted.count).to eq 1
    expect(AskAQuestionRequest.with_deleted.first.deleted_at).not_to be_nil
  end
end
