class Order < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :billing_address, class_name: 'Address'
  belongs_to :delivery_address, class_name: 'Address'
  has_and_belongs_to_many :products
  has_many :payments
  validate :nested_objects_valid

  private

  def nested_objects_valid
    if products
      products_with_errors = products.select { |p| p.invalid? }
      errors[:products] = "#{products_with_errors.count} product(s) have errors" if products_with_errors.present?
    end

    errors[:delivery_address] = 'Invalid delivery_address' if delivery_address && delivery_address.invalid?
    errors[:billing_address] = 'Invalid billing_address' if billing_address && billing_address.invalid?
  end

end
