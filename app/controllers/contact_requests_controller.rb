class ContactRequestsController < ApplicationController
  def create
    ContactRequest.create!(params[:contact_request].permit(:name, :email, :phone, :subject, :message))
  end
end
