require 'spec_helper'

describe ContactRequest do
  it { should validate_presence_of :name }
  it { should validate_presence_of :email }
  it { should validate_presence_of :message }

  it 'has soft delete' do
    ContactRequest.create!(name: 'name', email: 'user@example.com', message: 'test').destroy
    expect(ContactRequest.with_deleted.count).to eq 1
    expect(ContactRequest.with_deleted.first.deleted_at).not_to be_nil
  end
end
