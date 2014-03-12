class Product < ActiveRecord::Base
  validates_presence_of :name, :price_in_aud, :price_in_usd, :priority
  validate :no_dashes_in_product_name
  acts_as_paranoid
  has_many :images

  def slug
    name.parameterize
  end

  private

  def no_dashes_in_product_name
    if name && name.include?('-')
      errors.add :name, I18n.t('activerecord.errors.models.product.attributes.name.has_dashes')
    end
  end
end
