class CheckoutController < ApplicationController
  def index
    @order = CheckoutService.order_from request.session_options[:id], session[:order]
  end

  def update
    session[:order] = CheckoutService.update_session session[:order], params[:order]
    redirect_to confirm_checkout_path
  end

  def confirm
    @order = CheckoutService.order_from request.session_options[:id], session[:order]
  end

  def confirmed
    @order = CheckoutService.save request.session_options[:id], session[:order], session[:cart]
    @payment_request = CheckoutService.create_payment_for @order
    redirect_to @payment_request.redirect_uri
  end

  def success
  end

  def cancel
  end
end
