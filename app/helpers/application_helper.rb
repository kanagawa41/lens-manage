module ApplicationHelper
  def partial_stylesheet_link_tag(controller_name, initialize_name, disabled = true)
    if disabled == false || disabled.nil?
      return stylesheet_link_tag "#{controller_name}/#{initialize_name}"
    end
  end
end
