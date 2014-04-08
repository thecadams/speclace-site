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

  it 'validates products' do
    expect(Order.new(products: [FactoryGirl.build(:product)])).to be_valid

    order = Order.new(products: [FactoryGirl.build(:product, image_1: nil)])
    expect(order).not_to be_valid
    expect(order.errors[:products]).to eq ['1 product(s) have errors']
  end

  it 'validates delivery_address' do
    expect(Order.new(delivery_address: FactoryGirl.build(:address))).to be_valid

    order = Order.new(delivery_address: FactoryGirl.build(:address, first_name: nil))
    expect(order).not_to be_valid
    expect(order.errors[:delivery_address]).to eq ['Invalid delivery_address']
  end

  it 'validates billing_address' do
    expect(Order.new(billing_address: FactoryGirl.build(:address))).to be_valid

    order = Order.new(billing_address: FactoryGirl.build(:address, first_name: nil))
    expect(order).not_to be_valid
    expect(order.errors[:billing_address]).to eq ['Invalid billing_address']
  end
end
