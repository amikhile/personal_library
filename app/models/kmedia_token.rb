class KmediaToken
  include ActiveModel::Validations


  def self.get_token
    response = RestClient.post "#{APP_CONFIG['kmedia_url']}/admin/api/tokens.json",
                               :email => APP_CONFIG['kmedia_user'], :password => APP_CONFIG['kmedia_password'], :content_type => :json

    hash = JSON.parse response
    hash['token']
  end
end