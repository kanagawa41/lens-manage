module ApplicationHelper
	R_COLOR_RANGE = [*0..255]
	G_COLOR_RANGE = [*0..255]
	B_COLOR_RANGE = [*0..255]

  def partial_stylesheet_link_tag(controller_name, initialize_name, disabled = true)
    if disabled == false || disabled.nil?
      return stylesheet_link_tag "#{controller_name}/#{initialize_name}"
    end
  end

  def sample_color
		r = R_COLOR_RANGE.sample
		g = G_COLOR_RANGE.sample
		b = B_COLOR_RANGE.sample
		color = "##{"%02x"%r}#{"%02x"%g}#{"%02x"%b}"
  end
end
