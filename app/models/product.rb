class Product < ActiveRecord::Base
  validates_presence_of :name, :price_in_aud, :price_in_usd, :priority
  validate :no_dashes_in_product_name
  validate :product_name_titleized
  acts_as_paranoid
  has_many :images
  belongs_to :product_badge

  def slug
    name.parameterize
  end

  private

  def no_dashes_in_product_name
    if name && name.include?('-')
      errors.add :name, I18n.t('activerecord.errors.models.product.attributes.name.has_dashes')
    end
  end

  def product_name_titleized
    if name && name != name.titleize
      errors.add :name, I18n.t('activerecord.errors.models.product.attributes.name.not_titleized')
    end
  end
end
