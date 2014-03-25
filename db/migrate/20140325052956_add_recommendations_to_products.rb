class AddRecommendationsToProducts < ActiveRecord::Migration
  def change
    add_column :products, :recommendation_1_id, :integer
    add_column :products, :recommendation_2_id, :integer
    add_column :products, :recommendation_3_id, :integer
    add_column :products, :recommendation_4_id, :integer
    add_column :products, :recommendation_5_id, :integer
  end
end
