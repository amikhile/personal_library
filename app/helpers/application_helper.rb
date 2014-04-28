module ApplicationHelper
  def nav_link(text, link, current_label, selected_label)
    recognized = Rails.application.routes.recognize_path(link)
    active = recognized[:controller] == params[:controller]  && current_label.id == selected_label.to_i
    do_nav_link(text, link, active)
  end


  def do_nav_link(text, link, active)
      active = active ? "active" : ""
      content_tag(:li, :class => active) do
        link_to(text, link)
      end
  end

  def is_gmail_user
    return current_user.email.end_with?("@gmail.com")
  end

  def is_text_document (type)
    #html,htm,txt,doc,pdf,rtf,epu,epub
    text_extensions = ['html', 'htm', 'txt', 'doc', 'pdf', 'rtf', 'epu', 'epub']
    return text_extensions.include? type
  end

  def get_dowload_to_text(filter)
    text=''
    text+= t('ui.content.mobile')  if filter.download_mobile
    text+= ", "  if filter.download_mobile && filter.download_pc
    text+= t('ui.content.pc') if filter.download_pc
    text
  end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = (column == sort_column) ? "current #{sort_direction}" : nil
    direction = (column == sort_column && sort_direction == "asc") ? "desc" : "asc"
    link_to title, {:sort => column, :direction => direction}, {:class => css_class}
  end
end
