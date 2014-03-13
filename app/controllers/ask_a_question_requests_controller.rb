class AskAQuestionRequestsController < ApplicationController
  def create
    AskAQuestionRequest.create!(params[:ask_a_question_request].permit(:name, :email, :question, :product_id))
  end
end
