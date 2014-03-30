require 'spec_helper'

describe Order do
  it { should belong_to(:billing_address).class_name('Address') }
  it { should belong_to(:delivery_address).class_name('Address') }
  it { should have_and_belong_to_many :products }
  it { should have_many :payments }

  it 'has soft delete' do
    Order.create!.destroy
    expect(Order.with_deleted.count).to eq 1
    expect(Order.with_deleted.first.deleted_at).not_to be_nil
  end
end
