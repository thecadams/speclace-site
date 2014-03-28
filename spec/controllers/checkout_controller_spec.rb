require 'spec_helper'

describe CheckoutController do
  describe '#index' do
    it 'builds an order from session'
  end

  describe '#update' do
    it 'updates the session'
    it 'redirects to the confirm page'
  end

  describe '#confirm' do
    it 'builds an order from session'
  end

  describe '#confirmed' do
    it 'saves the order'
    it 'saves a payment record'
  end

  describe '#success' do
    it 'checks paypal parameters are present'
    it 'looks up the order based on session id, or by token, not sure which yet'
    it 'updates the payment record'
    it 'removes the order from the session'
  end

  describe '#cancel' do
    it 'checks paypal parameters are present'
    it 'sets a flash'
    it 'redirects to the cart'
  end
end
