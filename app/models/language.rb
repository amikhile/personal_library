class Language < ActiveRecord::Base
  has_and_belongs_to_many :filters


  # code3 => locale
  CODE3_LOCALE = Hash.new('en')
  Language.all.map{|l| CODE3_LOCALE[l.code3] = l.locale}
  CODE3_LOCALE.freeze

  # locale => code3
  LOCALE_CODE3 = Hash.new('ENG')
  Language.all.map{|l| LOCALE_CODE3[l.locale] = l.code3}
  LOCALE_CODE3.freeze

  def self.get_languages
    if Language.all.empty? || APP_CONFIG['reload'] == 'true'
      languages = get_from_kmedia
      Language.delete_all
      save_languages(languages)
    end
    Language.all
  end

  def to_s
    "#{language} (#{code3.upcase})"
  end

  def self.menu_languages(*languages)
    Language.where(:locale => languages).multipluck(:locale, :language)
  end

  private
  def self.save_languages(languages)
    languages.each { |l|
      language = Language.find_or_create_by_kmedia_id(l['id'])
      language.language = l['language']
      language.code3 = l['code3']
      language.locale = l['locale']
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