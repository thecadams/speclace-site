class Product < ActiveRecord::Base
  validates_presence_of :name, :price_in_aud, :priority, :stock_level, :image_1, :image_2, :image_3, :product_range
  validate :no_dashes_in_product_name
  validate :name_titleized
  acts_as_paranoid
  belongs_to :image_1, class_name: 'Image'
  belongs_to :image_2, class_name: 'Image'
  belongs_to :image_3, class_name: 'Image'
  belongs_to :image_4, class_name: 'Image'
  belongs_to :recommendation_1, class_name: 'Product'
  belongs_to :recommendation_2, class_name: 'Product'
  belongs_to :recommendation_3, class_name: 'Product'
  belongs_to :recommendation_4, class_name: 'Product'
  belongs_to :recommendation_5, class_name: 'Product'
  belongs_to :product_badge
  belongs_to :product_range
  has_and_belongs_to_many :product_colours

  def slug
    name.parameterize
  end

  def images
    image_4.nil? ?
      [image_1, image_2, image_3] :
      [image_1, image_2, image_3, image_4]
  end

  def recommendations
    recommendations = [recommendation_1, recommendation_2, recommendation_3, recommendation_4, recommendation_5]

    number_to_fill_in_automatically = recommendations.select {|r| r.nil?}.count
    if number_to_fill_in_automatically > 0
      from_same_range = Product.where('id!=? and product_range_id=? and stock_level>0', id, product_range_id).order(stock_level: :desc)
      from_other_ranges = Product.includes(:product_range).where('product_range_id!=? and stock_level>0', product_range_id).order('product_ranges.name', stock_level: :desc)

      automatic_recommendations = from_same_range.to_a.concat from_other_ranges.to_a
      automatic_recommendations.delete recommendation_1
      automatic_recommendations.delete recommendation_2
      automatic_recommendations.delete recommendation_3
      automatic_recommendations.delete recommendation_4
      automatic_recommendations.delete recommendation_5

      (0..4).each do |i|
        if recommendations[i].nil?
          recommendations[i] = automatic_recommendations.shift
        end
      end
    end

    recommendations.select {|r| r.present?}
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
