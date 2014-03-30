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
    @paypal_payment = CheckoutService.create_payment_for @order, checkout_success_url, checkout_cancel_url
    redirect_to CheckoutService.redirect_url_for(@paypal_payment)
  end

  def success
    raise 'valid PayPal response parameters required' unless params['token'] && params['PayerID']
    begin
      CheckoutService.complete_payment(params['token'], params['PayerID'])
      session.delete(:order)
    rescue => e
      Rails.logger.error "#{e.message}: #{e.backtrace}"
      flash[:error] = "Sorry, we had a problem completing your payment with PayPal: '#{e.message}'. Please try again."
      redirect_to confirm_checkout_path
    end
  end

  def cancel
    flash[:error] = "Looks like you canceled your payment. We've sent you to your cart in case you want to try again."
    redirect_to cart_path
  end
end
