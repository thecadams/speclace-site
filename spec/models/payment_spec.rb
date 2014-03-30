require 'spec_helper'

describe Payment do
  it { should belong_to :order }
  it { should validate_presence_of :order }

  it 'has soft delete' do
    Payment.create!(order: Order.create!).destroy
    expect(Payment.with_deleted.count).to eq 1
    expect(Payment.with_deleted.first.deleted_at).not_to be_nil
  end
end
