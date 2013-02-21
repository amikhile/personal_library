class Language < ActiveRecord::Base
  has_and_belongs_to_many :filters


  def self.get_languages
    if Language.all.empty?
      languages = get_from_kmedia
      save_languages(languages)
    end
    Language.all
  end


  private
  def self.save_languages(languages)
    languages.each { |c|
      language = Language.new
      language.name = c['language']
      language.kmedia_id = c['id']
      language.save
    }

  end

  def self.get_from_kmedia
    token = KmediaToken.get_token
    response = RestClient.post "#{APP_CONFIG['kmedia_url']}/admin/api/api/languages.json",
                               :auth_token => token, :content_type => :json

    hash = JSON.parse response
    hash['item']
  end
end