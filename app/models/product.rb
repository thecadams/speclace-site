class Product < ActiveRecord::Base
  validates_presence_of :name, :price_in_aud, :price_in_usd, :priority, :stock_level, :image_1, :image_2, :image_3
  validate :no_dashes_in_product_name
  validate :name_titleized
  acts_as_paranoid
  belongs_to :image_1, class_name: 'Image'
  belongs_to :image_2, class_name: 'Image'
  belongs_to :image_3, class_name: 'Image'
  belongs_to :image_4, class_name: 'Image'
  belongs_to :product_badge
  belongs_to :product_range

  def slug
    name.parameterize
  end

  def images
    image_4.nil? ?
      [image_1, image_2, image_3] :
      [image_1, image_2, image_3, image_4]
  end

  private

  def no_dashes_in_product_name
    if name && name.include?('-')
      errors.add :name, I18n.t('activerecord.errors.models.product.attributes.name.has_dashes')
    end
  end

  def name_titleized
    if name && name != name.titleize
      errors.add :name, I18n.t('activerecord.errors.models.product.attributes.name.not_titleized')
    end
  end
end
