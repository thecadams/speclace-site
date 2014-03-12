class Image < ActiveRecord::Base
  validates_presence_of :url
  acts_as_paranoid
  belongs_to :product
end
