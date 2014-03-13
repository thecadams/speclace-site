class CreateAskAQuestionRequests < ActiveRecord::Migration
  def change
    create_table :ask_a_question_requests do |t|
      t.belongs_to :product, null: false
      t.string :name, null: false
      t.string :email, null: false
      t.text :question, null: false
      t.timestamps
      t.datetime :deleted_at
    end
  end
end
