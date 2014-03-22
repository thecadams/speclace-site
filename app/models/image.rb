class Image < ActiveRecord::Base
  validates_presence_of :product
  acts_as_paranoid
  belongs_to :product
  has_attached_file :image, styles: {
    small: '100x100>',
    medium: '400x400>',
    large: '700x700>'
  }
  validates :image, attachment_presence: true
  validates :image, attachment_size: { less_than: 2.megabytes }
  validates :image, attachment_content_type: { content_type: /image\/(png|gif|jpe?g)/ }

  def name
    "Image for '#{product.try(:name)}': '#{alt}'"
  end
end
