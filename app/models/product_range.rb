class ProductRange < ActiveRecord::Base
  validates_presence_of :name
  validate :name_titleized
  has_many :products

  def slug
    name.parameterize
  end

  private

  def name_titleized
    if name && name != name.titleize
      errors.add :name, I18n.t('activerecord.errors.models.product_range.attributes.name.not_titleized')
    end
  end
end
