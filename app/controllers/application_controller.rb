class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :load_main_menu_navigation, :load_cart

  private

  def load_main_menu_navigation
    @main_menu_navigation_items = NavigationItem.where(menu_name: 'main').order(:parent_id, :order_within_parent)
  end

  def load_cart
    return unless session[:cart].present?
    @cart_item_count = session[:cart].values.sum
    @cart_total = session[:cart].map { |product_id, quantity| Product.find(product_id).price_in_aud * quantity }.sum
  end
end
