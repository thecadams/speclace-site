class ProductBadge < ActiveRecord::Base
  validates_presence_of :name
  acts_as_paranoid
  belongs_to :product_badge_css_class
end
