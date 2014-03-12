Speclace::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  root 'pages#home'

  get '/ranges/:name', as: :ranges, to: 'ranges#show'

  get '/about-us', as: :about_us, to: 'pages#about_us'
  get '/copyright', as: :copyright, to: 'pages#copyright'
  get '/contact-us', as: :contact_us, to: 'pages#contact_us'
  get '/frequently-asked-questions', as: :frequently_asked_questions, to: 'pages#frequently_asked_questions'
  get '/postage-and-shipping', as: :postage_and_shipping, to: 'pages#postage_and_shipping'
  get '/how-do-i-pay-my-order', as: :how_do_i_pay_my_order, to: 'pages#how_do_i_pay_my_order'
  get '/internet-security', as: :internet_security, to: 'pages#internet_security'
  get '/refund-policy', as: :refund_policy, to: 'pages#refund_policy'
  get '/privacy-policy', as: :privacy_policy, to: 'pages#privacy_policy'

  post '/contact-request', as: :contact_request, to: 'contact_requests#create'
end
