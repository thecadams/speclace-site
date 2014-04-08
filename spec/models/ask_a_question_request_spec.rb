require 'spec_helper'

describe AskAQuestionRequest do
  it { should belong_to :product }
  it { should validate_presence_of :product_id }
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :question }

  it 'has soft delete' do
    AskAQuestionRequest.create!(name: 'name', email: 'user@example.com', question: 'test', product: FactoryGirl.create(:product)).destroy
    expect(AskAQuestionRequest.with_deleted.count).to eq 1
    expect(AskAQuestionRequest.with_deleted.first.deleted_at).not_to be_nil
  end
end
