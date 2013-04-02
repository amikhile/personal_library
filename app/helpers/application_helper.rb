module ApplicationHelper
  def nav_link(text, link, current_label, selected_label)
    recognized = Rails.application.routes.recognize_path(link)
    active = recognized[:controller] == params[:controller] && recognized[:action] == params[:action] && current_label.id == selected_label.to_i
    do_nav_link(text, link, active)
  end


  def do_nav_link(text, link, active)
      active = active ? "active" : ""
      content_tag(:li, :class => active) do
        link_to(text, link)
      end
  end

end
