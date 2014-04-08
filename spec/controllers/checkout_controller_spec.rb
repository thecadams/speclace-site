require 'spec_helper'

describe CheckoutController do
  before { init_session }

  describe '#index' do
    it 'copes with uninitialized session' do
      session.delete :order
      expect {get :index}.not_to raise_error
    end

    it 'builds an order from session' do
      get :index
      expect(assigns(:order).attributes).to eq populated_order.attributes
    end
  end

  describe '#update' do
    it 'sets a flash and redirects on invalid order' do
      post :update, order: {delivery_address: {first_name: nil}}
      expect(flash[:error]).to eq 'There were some problems with your order. Please fix them before continuing.'
      expect(response).to redirect_to checkout_path
    end

    it 'updates the session' do
      post :update, order: {delivery_address: {first_name: 'something else'}}
      expect(session[:order][:delivery_address][:first_name]).to eq 'something else'
    end

    it 'redirects to the confirm page' do
      post :update
      expect(response).to redirect_to confirm_checkout_path
    end

    it 'supports back' do
      post :update, back: 'Back'
      expect(response).to redirect_to cart_path
    end

    it 'does not validate when going back' do
      post :update, back: 'Back', order: {delivery_address: {first_name: nil}}
      expect(flash[:error]).to be_nil
      expect(response).to redirect_to cart_path
    end
  end

  describe '#confirm' do
    it 'copes with uninitialized session' do
      session.delete :order
      expect {get :index}.not_to raise_error
    end

    it 'builds an order from session' do
      get :confirm
      expect(assigns(:order).attributes).to eq populated_order.attributes
    end
  end

  describe '#confirmed' do
    before do
      CheckoutService.stub(:save!)
      CheckoutService.stub(:create_payment_for)
      CheckoutService.stub(:redirect_url_for) { 'http://paypal.example.com/' }
    end

    it 'saves the order and a payment record' do
      product = FactoryGirl.create(:product, name: 'Example')
      session[:cart] = {product.id => 1}
      post :confirmed
      expect(CheckoutService).to have_received(:save!).with(request.session_options[:id], session[:order], {product.id => 1})
    end

    it 'prepares a paypal payment' do
      CheckoutService.stub(:save!) { :order }
      post :confirmed
      expect(CheckoutService).to have_received(:create_payment_for).with(:order, checkout_success_url, checkout_cancel_url)
    end

    it 'issues a redirect to paypal' do
      post :confirmed
      expect(response).to redirect_to 'http://paypal.example.com/'
    end

    it 'send the user back if there is a problem saving' do
      CheckoutService.stub(:save!).and_raise 'woof'
      Rails.stub_chain(:logger, :error)
      post :confirmed
      expect(flash[:error]).to eq "There was a problem saving your order: 'woof'. Please try again."
      expect(Rails.logger).to have_received(:error)
      expect(response).to redirect_to confirm_checkout_path
    end

    it 'supports back' do
      post :confirmed, back: 'Back'
      expect(response).to redirect_to checkout_path
    end

    it 'does not validate when going back' do
      CheckoutService.stub(:save!).and_raise 'the roof'
      post :confirmed, back: 'Back'
      expect(response).to redirect_to checkout_path
    end
  end

  describe '#success' do
    it 'checks paypal parameters are present' do
      expect { get :success }.to raise_error 'valid PayPal response parameters required'
    end

    it 'completes the payment' do
      CheckoutService.stub(:complete_payment)
      get :success, token: 'payment_id', 'PayerID' => 'payer_id'
      expect(CheckoutService).to have_received(:complete_payment).with('payment_id', 'payer_id')
    end

    it 'removes the order from the session' do
      CheckoutService.stub(:complete_payment)
      get :success, token: 'payment_id', 'PayerID' => 'payer_id'
      expect(session[:order]).to be_nil
    end

    context 'when the payment did not complete' do
      before do
        CheckoutService.stub(:complete_payment).and_raise 'error'
        Rails.logger.stub(:error)
      end

      it 'logs the error' do
        get :success, token: 'payment_id', 'PayerID' => 'payer_id'
        expect(Rails.logger).to have_received(:error).once
      end

      it 'sets a flash' do
        get :success, token: 'payment_id', 'PayerID' => 'payer_id'
        expect(flash[:error]).to eq "Sorry, we had a problem completing your payment with PayPal: 'error'. Please try again."
      end

      it 'redirects to the checkout confirm page' do
        get :success, token: 'payment_id', 'PayerID' => 'payer_id'
        expect(response).to redirect_to confirm_checkout_path
      end
    end
  end

  describe '#cancel' do
    it 'sets a flash' do
      get :cancel
      expect(flash[:error]).to eq "Looks like you canceled your payment. We've sent you to your cart in case you want to try again."
    end

    it 'redirects to the cart' do
      get :cancel
      expect(response).to redirect_to cart_path
    end
  end

  describe '#subregion_options' do
    it 'renders partial' do
      get :subregion_options
      expect(response).to render_template partial: '_subregion_select'
    end
  end

  def init_session
    session[:order] = {}
    session[:order][:delivery_address] = {}
    session[:order][:delivery_address][:first_name] = 'first'
    session[:order][:delivery_address][:last_name] = 'last'
    session[:order][:delivery_address][:company] = 'company'
    session[:order][:delivery_address][:street_address_1] = 'street address 1'
    session[:order][:delivery_address][:street_address_2] = 'street address 2'
    session[:order][:delivery_address][:city] = 'city'
    session[:order][:delivery_address][:postcode] = '3000'
    session[:order][:delivery_address][:state] = 'state'
    session[:order][:delivery_address][:country] = 'country'
    session[:order][:delivery_address][:email] = 'email'
    session[:order][:delivery_address][:phone] = 'phone'
    session[:order][:billing_address] = {}
    session[:order][:billing_address][:first_name] = 'first'
    session[:order][:billing_address][:last_name] = 'last'
    session[:order][:billing_address][:company] = 'company'
    session[:order][:billing_address][:street_address_1] = 'street address 1'
    session[:order][:billing_address][:street_address_2] = 'street address 2'
    session[:order][:billing_address][:city] = 'city'
    session[:order][:billing_address][:postcode] = '3000'
    session[:order][:billing_address][:state] = 'state'
    session[:order][:billing_address][:country] = 'country'
    session[:order][:billing_address][:email] = 'email'
    session[:order][:billing_address][:phone] = 'phone'
    session[:order][:comments] = 'comments'
  end

  def populated_order
    Order.new(
      session_id: request.session_options[:id],
      delivery_address: populated_address,
      billing_address: populated_address,
      comments: 'comments'
    )
  end

  def populated_address
    Address.new(
      first_name: 'first',
      last_name: 'last',
      company: 'company',
      street_address_1: 'street address 1',
      street_address_2: 'street address 2',
      city: 'city',
      postcode: '3000',
      state: 'state',
      country: 'country',
      email: 'email',
      phone: 'phone'
    )
  end
end
