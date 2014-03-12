class ContactRequest < ActiveRecord::Base
  validates_presence_of :name, :email, :message
  acts_as_paranoid
end
