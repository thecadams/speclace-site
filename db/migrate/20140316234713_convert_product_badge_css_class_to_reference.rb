class ConvertProductBadgeCssClassToReference < ActiveRecord::Migration
  def change
    remove_column :product_badges, :css_class
    add_reference :product_badges, :product_badge_css_class, index: true
  end
end
