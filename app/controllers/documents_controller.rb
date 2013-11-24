require 'google_drive/google_docs'
require 'open-uri'

class DocumentsController < ApplicationController
  before_filter :google_drive_login, :only => [:open_in_google_docs]


  def open_in_google_docs
    # if redirect is needed to google for authorization the selected inbox file id is stored in session
    @inbox_file = InboxFile.find(params[:id].present? ? params[:id] : session[:inbox_file_id])

    # find if file already present in personal library folder in user's drive
    file_in_drive = find_file(@inbox_file.kmedia_file.name)
    if file_in_drive.present?
      redirect_to file_in_drive.human_url
    else
      #download the file from kmedia to the tmp folder
      tmp_file = File.join("#{Rails.root}/tmp", @inbox_file.kmedia_file.name)
      # wb , w for write permissions , b for binary
      open(tmp_file, 'wb') do |file|
        file << open(@inbox_file.kmedia_file.url).read
      end

      # upload the file to user's google drive
      upload_file(tmp_file, @inbox_file.kmedia_file.name)
    end
  end

  def find_file(file_name)
    google_session = GoogleDrive.login_with_oauth(session[:google_token])
    library_dir = get_personal_library_folder
    library_dir.file_by_title(file_name)
  end

  def get_personal_library_folder
    google_session = GoogleDrive.login_with_oauth(session[:google_token])
    library_dir = google_session.root_collection.subcollection_by_title("Personal library")
    unless library_dir.present?
      library_dir =  google_session.root_collection.create_subcollection("Personal library")
    end
    library_dir
  end

  def upload_file(file_path, file_name)
    google_session = GoogleDrive.login_with_oauth(session[:google_token])
    file = google_session.upload_from_file(file_path, file_name, :convert => true)
    file = google_session.file_by_title(file_name)
    get_personal_library_folder.add(file)
    google_session.root_collection.remove(file)
    FileUtils.rm file_path, :force => true
    redirect_to file.human_url
  end


  def set_google_drive_token
    google_doc = GoogleDrive::GoogleDocs.new("#{APP_CONFIG['GOOGLE_CLIENT_ID']}", "#{APP_CONFIG['GOOGLE_CLIENT_SECRET']}",
                                             "#{APP_CONFIG['GOOGLE_CLIENT_REDIRECT_URI']}")
    oauth_client = google_doc.create_google_client
    auth_token = oauth_client.auth_code.get_token(params[:code], redirect_uri: "#{APP_CONFIG['GOOGLE_CLIENT_REDIRECT_URI']}")
    update_session_with_google_auth_token auth_token
    open_in_google_docs
  end

  def google_drive_login
    google_doc = GoogleDrive::GoogleDocs.new("#{APP_CONFIG['GOOGLE_CLIENT_ID']}", "#{APP_CONFIG['GOOGLE_CLIENT_SECRET']}",
                                             "#{APP_CONFIG['GOOGLE_CLIENT_REDIRECT_URI']}")
    oauth_client = google_doc.create_google_client
    auth_token = OAuth2::AccessToken.from_hash(oauth_client,
                                               {:refresh_token => session[:google_refresh_token],
                                                :expires_at => session[:google_token_expires_at]})
    if !session[:google_token].present? || auth_token.expired?
      session[:inbox_file_id] = params[:id]

      auth_url = google_doc.set_google_authorize_url
      redirect_to auth_url
    end
  end


  private
  def update_session_with_google_auth_token auth_token
    session[:google_token] = auth_token.token
    session[:google_token_expires_at] = auth_token.expires_at
  end
end