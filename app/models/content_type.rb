class ContentType < ActiveRecord::Base

  has_and_belongs_to_many :filters, :join_table => "filters_content_types"

  def self.get_content_types
    if ContentType.all.empty?
      content_types = get_from_kmedia
      save_content_types(content_types)
    end
    ContentType.all
  end


  private
  def self.save_content_types(content_types)
    content_types.each { |c|
      content_type = ContentType.new
      content_type.name = c['name']
      content_type.kmedia_id = c['id']
      content_type.save
    }

  end

  def self.get_from_kmedia
    token = KmediaToken.get_token
    response = RestClient.post 'http://localhost:4000/admin/api/api/content_types.json',
                               :auth_token => token, :content_type => :json

    #response = RestClient.post 'http://kmedia.kbb1.com/admin/api/api/content_types.json',
    #                           :auth_token => token, :content_type => :json


    hash = JSON.parse response
    hash['item']
  end

end