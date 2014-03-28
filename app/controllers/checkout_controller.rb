class CheckoutController < ApplicationController
  # get /checkout
  def index
    # checkout
    # show form based on session vars
  end

  # post /checkout
  def update
    # posted from #index
    # update session
    # redirect to /checkout/confirm
    redirect_to confirm_checkout_path
  end

  # get /confirm
  def confirm
    # redirected from #update
    # show confirm checkout step
  end

  # post /confirm
  def confirmed
    # save order with session id
    # prepare paypal payment
    # issue paypal redirect
  end

  # get /success
  def success
    # success from paypal
    # lookup order by session id & most recent
    # if no order could be found, that is ok
  end

  # get /cancel
  def cancel
    # set flash about cancellation
    # redirect to cart
  end
end
