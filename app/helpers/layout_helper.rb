# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def stylesheet(*args)
    content_for(:stylesheets) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:javascripts) { javascript_include_tag(*args) }
  end


  def display_errors(f)
    engine = Haml::Engine.new <<-HAML
- if form.error_notification
  .alert.alert-error.fade.in
    %a.close(data-dismiss="alert" href="#") &times;
    = form.error_notification :class => 'no-margin'
  %hr.soften
    HAML
    engine.render self, :form => f
  end

  def display_actions(f, location)
    engine = Haml::Engine.new <<-HAML
.actions
  %button.btn.btn-primary.btn-large{:type => 'submit', :'data-disable-with' => 'Please wait...'} Update
  %button.btn.btn-large{:onclick => "location.href='#{location}'; return false;", :type => 'button'} Cancel
HAML
    engine.render self, :form => f
  end

  def display_actions_filter_form(f, location)
    engine = Haml::Engine.new <<-HAML
.actions
  %button.btn.btn-primary.btn-large{:onclick => "get_selected_catalogs(this); return true", :type => 'submit', :'data-disable-with' => 'Please wait...'} Update
  %button.btn.btn-large{:onclick => "location.href='#{location}'; return false;", :type => 'button'} Cancel
    HAML
    engine.render self, :form => f
  end


  def display_show_item(name, value, as_is = false)
    engine = Haml::Engine.new <<-HAML
%p
  %strong #{name.humanize}:
  #{as_is ? value : value.to_s.gsub(/\s/, '&nbsp;')}
HAML
    engine.render
  end

end
