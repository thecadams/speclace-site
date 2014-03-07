module ApplicationHelper
  def nav_class(nav_item)
    request.original_fullpath.downcase == nav_item.href.downcase ? 'active' : nil
  end
end
