class Order < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :billing_address, class_name: 'Address'
  belongs_to :delivery_address, class_name: 'Address'
  has_and_belongs_to_many :products
  has_many :payments
end
