class Payment < ActiveRecord::Base
  validates_presence_of :order
  belongs_to :order
  acts_as_paranoid
end
