class ProductColour < ActiveRecord::Base
  validates_presence_of :name
  validate :name_titleized
  has_and_belongs_to_many :products

  def slug
    name.parameterize
  end

  private

  def name_titleized
    if name && name != name.titleize
      errors.add :name, I18n.t('activerecord.errors.models.product_colour.attributes.name.not_titleized')
    end
  end
end
