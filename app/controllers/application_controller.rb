class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :mailer_set_url_options, :check_logged_in, :authenticate_user!
  before_filter :load_filters_and_labels

  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def check_logged_in
     unless current_user
       redirect_to "/users/my_sign_in"
     end
  end

  def load_filters_and_labels
    @filters_for_menu = current_user.filters.order(:name)
    @labels_for_menu = current_user.labels.order(:name)
  end

  def load_from_kmedia
    @content_types = ContentType.get_content_types.map { |ct| [ct['name'], ct['id']] }
    @media_types = MediaType.get_media_types.map { |mt| [mt['name'], mt['id']] }
    @languages = Language.get_languages.map { |l| [l['name'], l['id']] }
  end


end
