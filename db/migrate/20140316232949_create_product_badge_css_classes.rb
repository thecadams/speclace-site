class CreateProductBadgeCssClasses < ActiveRecord::Migration
  def change
    create_table :product_badge_css_classes do |t|
      t.string :name, null: false
    end
  end
end
