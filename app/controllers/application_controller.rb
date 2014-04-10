class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :mailer_set_url_options, :set_locale, :check_logged_in, :authenticate_user!,  :load_filters_and_labels


  def mailer_set_url_options
    ActionMailer::Base.default_url_options[:host] = request.host_with_port
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  private

  def check_logged_in
     unless current_user
       redirect_to "/users/my_sign_in"
     end
  end

  def load_filters_and_labels
    @ids = params[:selected_files].split(",") rescue []
    @filters_for_menu = current_user.filters.order(:name)
    @labels_for_menu = current_user.labels.order(:name)
    init_selected_filter_and_label_from_cookies
  end

  def init_selected_filter_and_label_from_cookies
    @selected_filter = cookies[:filter] if cookies[:filter].present? && Filter.find_by_id(cookies[:filter])
    @selected_label = cookies[:label] if cookies[:label].present? && Label.find_by_id(cookies[:label])
  end


  def load_from_kmedia
    @content_types = ContentType.get_content_types.map { |ct| [t('ui.content-type.'+ct['name']), ct['id']] }
    @media_types = MediaType.get_media_types.map { |mt| [t('ui.media-type.'+mt['name']), mt['id']] }
    @languages = Language.get_languages.map { |l| [l['language'], l['id']] }
  end

  def export_to_file(files, export_file_name)
    begin
      tmp_file = Tempfile.open("export-#{export_file_name}", Rails.root.join('tmp'))
      files.each do |data|
        tmp_file.write(data['name'] +' ---> '+data['url']+"\r\n")
      end
      send_file tmp_file.path, :filename => export_file_name, :x_sendfile => true, :content_type => 'text/plain'
    ensure
      tmp_file.close
    end
  end


  # For any url_for (except devise)
  def default_url_options(options={})
    {:locale => (params[:locale] || I18n.locale)}
  end

  # Devise plugin only
  def self.default_url_options(options={})
    {:locale => I18n.locale}
  end

  private

  def set_locale
    I18n.locale = @locale = params[:locale] || cookies[:library_locale] || 'en'
    cookies[:library_locale] = @locale
    @menu_languages = Language.menu_languages('en', 'he', 'ru').map{|x| [x['language'], root_url(x['locale'])]}
    @current_menu_language = root_url(@locale)
  end

end
