class AskAQuestionRequest < ActiveRecord::Base
  validates_presence_of :product_id, :name, :email, :question
  acts_as_paranoid
  belongs_to :product
end
