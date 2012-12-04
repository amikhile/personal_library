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

  def display_actions_with_mark(f, location)
    engine = Haml::Engine.new <<-HAML
.actions
  %button.btn.btn-primary.btn-large{:type => 'submit', :'data-disable-with' => 'Please wait...'} Update
  %button.btn.btn-large{:onclick => "location.href='#{location}'; return false;", :type => 'button'} Cancel
  - if @lesson.lessonid && can?(:merge, @lesson)
    .merge.pull-right
      %button.mark_for_merge.btn{:onclick => "mark_me(this); return false;", :'data-mark-path' => mark_for_merge_admin_lesson_path(@lesson), :class => @lesson.marked_for_merge ? 'btn-warning' : '', :type => 'button'}
        = @lesson.marked_for_merge ? "Unmark" : "Mark"
      %button.btn.btn-danger{:onclick => "merge_to_me_get_list(this); return false;", :'data-merge-path' => merge_get_list_admin_lesson_path(@lesson)}= 'Merge Preview'
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

  def display_secure(secure_level)
    security = SECURITY.select{|s| s[:level] == secure_level }
    name = security.first[:name].downcase
    klass = security.first[:klass]
    name == 'unsecure' ? 'non-secure' : "<span class='label label-#{klass}'>#{name.humanize}</span>".html_safe
  end

  def display_visibility(visibility)
    visibility ? 'Visible' : 'Hidden'
  end

  def display_catalog_state(state)
    state ? 'Open' : 'Closed'
  end


end
