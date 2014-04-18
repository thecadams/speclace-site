Speclace::Application.routes.draw do
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'
  root 'pages#home'

  get '/products', as: :products, to: 'products#index'
  get '/products/:slug', as: :product_details, to: 'products#show'

  get '/about-us', as: :about_us, to: 'pages#about_us'
  get '/copyright', as: :copyright, to: 'pages#copyright'
  get '/contact-us', as: :contact_us, to: 'pages#contact_us'
  get '/frequently-asked-questions', as: :frequently_asked_questions, to: 'pages#frequently_asked_questions'
  get '/postage-and-shipping', as: :postage_and_shipping, to: 'pages#postage_and_shipping'
  get '/how-do-i-pay-my-order', as: :how_do_i_pay_my_order, to: 'pages#how_do_i_pay_my_order'
  get '/internet-security', as: :internet_security, to: 'pages#internet_security'
  get '/refund-policy', as: :refund_policy, to: 'pages#refund_policy'
  get '/privacy-policy', as: :privacy_policy, to: 'pages#privacy_policy'
  get '/terms-and-conditions', as: :terms_and_conditions, to: 'pages#terms_and_conditions'
  get '/lampwork-beads', as: :lampwork_beads, to: 'pages#lampwork_beads'
  get '/payment-options', as: :payment_options, to: 'pages#payment_options'
  get '/do-you-ship-worldwide', as: :do_you_ship_worldwide, to: 'pages#do_you_ship_worldwide'

  post '/contact-request', as: :contact_request, to: 'contact_requests#create'
  post '/ask-a-question', as: :ask_a_question_request, to: 'ask_a_question_requests#create'

  get '/cart', as: :cart, to: 'cart#index'
  put '/cart', as: :update_cart, to: 'cart#update'
  put '/cart/add', as: :add_to_cart, to: 'cart#add'

  get '/checkout', as: :checkout, to: 'checkout#index'
  post '/checkout', as: :update_checkout, to: 'checkout#update'
  get '/checkout/confirm', as: :confirm_checkout, to: 'checkout#confirm'
  post '/checkout/confirm', as: :checkout_confirmed, to: 'checkout#confirmed'
  get '/checkout/success', as: :checkout_success, to: 'checkout#success'
  get '/checkout/cancel', as: :checkout_cancel, to: 'checkout#cancel'
  get '/checkout/subregion_options', to: 'checkout#subregion_options'
end
