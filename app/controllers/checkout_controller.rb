class CheckoutController < ApplicationController
  def index
    @order = CheckoutService.order_from request.session_options[:id], session[:order], session[:cart]
  end

  def update
    return redirect_to cart_path if params[:back]
    session[:order] = CheckoutService.update_session session[:order], params['order']

    if CheckoutService.order_from(request.session_options[:id], session[:order], session[:cart]).invalid?
      flash[:error] = 'There were some problems with your order. Please fix them before continuing.'
      redirect_to checkout_path
    else
      redirect_to confirm_checkout_path
    end
  end

  def confirm
    @order = CheckoutService.order_from request.session_options[:id], session[:order], session[:cart]
    @order_products = CheckoutService.product_counts(@order.products)
    @subtotal = @order_products.map { |product, quantity| product.price_in_aud * quantity }.sum
    @shipping = 3.95
    @total = @subtotal + @shipping
  end

  def confirmed
    return redirect_to checkout_path if params[:back]

    begin
      @order = CheckoutService.save! request.session_options[:id], session[:order], session[:cart]
      @paypal_payment = CheckoutService.create_payment_for @order, checkout_success_url, checkout_cancel_url
      redirect_to CheckoutService.redirect_url_for(@paypal_payment)
    rescue => e
      Rails.logger.error "Problem saving order: #{e}"
      flash[:error] = "There was a problem saving your order: '#{e.message}'. Please try again."
      redirect_to confirm_checkout_path
    end
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

  def subregion_options
    render partial: 'subregion_select'
  end
end
