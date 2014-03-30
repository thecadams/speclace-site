require 'spec_helper'

describe Address do
  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  it { should validate_presence_of :street_address_1 }
  it { should validate_presence_of :city }
  it { should validate_presence_of :postcode }
  it { should validate_presence_of :state }
  it { should validate_presence_of :country }
  it { should validate_presence_of :email }

  it 'has soft delete' do
    Order.create!.destroy
    expect(Order.with_deleted.count).to eq 1
    expect(Order.with_deleted.first.deleted_at).not_to be_nil
  end
end
