class KmediaToken
  include ActiveModel::Validations


  def self.get_token
    response = RestClient.post 'http://localhost:4000/admin/api/tokens.json',
                               :email => 'ana@email.com', :password => '123456', :content_type => :json

    #response = RestClient.post 'http://kmedia.kbb1.com/admin/api/tokens.json',
    #                           :email => 'annamik@gmail.com', :password => 'mili10', :content_type => :json

    #response = RestClient.post 'http://kmedia.kbb1.com/admin/api/tokens.json',
    #                           :email => 'annamik@gmail.com', :password => 'mili10', :content_type => :json

    hash = JSON.parse response
    hash['token']
  end
end