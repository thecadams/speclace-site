class CheckoutController < ApplicationController
  def index
  end

  def update
    redirect_to confirm_checkout_path
  end

  def confirm
  end

  def confirmed
    # save order with session id
    # prepare paypal payment
    # issue paypal redirect
  end

  def success
    # success from paypal
    # lookup order by session id & most recent
    # if no order could be found, that is ok
  end

  def cancel
    # set flash about cancellation
    # redirect to cart
  end
end
