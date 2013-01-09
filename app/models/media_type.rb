class MediaType < ActiveRecord::Base

  has_and_belongs_to_many :filters

  def self.get_media_types
    if MediaType.all.empty?
      media_types = get_from_kmedia
      save_media_types(media_types)
    end
    MediaType.all
  end


  private
  def self.save_media_types(media_types)
    media_types.each { |c|
      media_type = MediaType.new
      media_type.name = c['typename']
      media_type.kmedia_id = c['id']
      media_type.save
    }

  end

  def self.get_from_kmedia
    token = KmediaToken.get_token
    response = RestClient.post 'http://localhost:4000/admin/api/api/file_types.json',
                               :auth_token => token, :content_type => :json

    #response = RestClient.post 'http://kmedia.kbb1.com/admin/api/api/file_types.json',
    #                           :auth_token => token, :content_type => :json


    hash = JSON.parse response
    hash['item']
  end

end