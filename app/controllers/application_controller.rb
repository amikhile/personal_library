class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :mailer_set_url_options, :check_logged_in, :authenticate_user!

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

end
