class Address < ActiveRecord::Base
  validates_presence_of :first_name, :last_name, :street_address_1, :city, :state, :postcode, :country, :email
  acts_as_paranoid
end
