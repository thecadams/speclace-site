class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :load_main_menu_navigation

  private

  def load_main_menu_navigation
    @main_menu_navigation_items = NavigationItem.where(menu_name: 'main').order(:parent_id, :order_within_parent)
  end
end
