class KmediaClient

  def self.my_logger
    @@my_logger ||= Logger.new("#{Rails.root}/log/kmedia_client.log", 10, 1.megabytes)
  end

  def self.get_files_from_morning_lessons
    morning_lessons = []
    my_logger.debug("Requesting morning lessons files info from kmedia.")
    begin
      response = RestClient.post "#{APP_CONFIG['kmedia_url']}/admin/api/api/morning_lesson_files.json",
                                 nil
      kmedia_response = JSON.parse response
      my_logger.info("Files for morning lessons retrieved.")
    rescue => e
      my_logger.error("Unable to get files form morning lessons from kmedia , #{e.message}")
    end
    kmedia_response['morning_lessons']
  end

  def self.get_the_files_from_kmedia(ids_of_files_to_fetch, secure)
    files = []

    begin
      @token = KmediaToken.get_token
      response = RestClient.post "#{APP_CONFIG['kmedia_url']}/admin/api/api/files.json",
                                 auth_token: @token,
                                 ids: ids_of_files_to_fetch.join(","),
                                 secure: secure
      hash = JSON.parse response
      files = hash['item']
    rescue => e
      my_logger.error("Unable to get files ids from kmedia , #{e.message}")
    end
    files
  end

  def self.get_file_ids_from_kmedia(options = {})
    ids =[]
    begin
      @token = KmediaToken.get_token
      my_logger.info("Searching for files ids with parameters #{options}")
      options[:auth_token] = @token
      response = RestClient.post "#{APP_CONFIG['kmedia_url']}/admin/api/api/file_ids.json", options
      hash = JSON.parse response


      if (hash['error'])
        my_logger.error("Kmedia return #{hash['error']}")
      else
        ids = hash['ids']
        my_logger.info("Found #{ids.split(',').size} ids. Retrieved ids #{ids}")
      end
    rescue => e
      my_logger.error("Unable to get files ids from kmedia , #{e.message}")
    end
    ids
  end

  def self.get_catalogs_from_kmedia(options = {})
    retrieved_catalogs=[]
    begin
    token = KmediaToken.get_token
    response = RestClient.post "#{APP_CONFIG['kmedia_url']}/admin/api/api/catalogs.json",
                               auth_token: token, content_type: :json, root: options[:root], locale: I18n.locale
    hash = JSON.parse response
    retrieved_catalogs = hash['item'].sort_by { |e| e['name'] }
    rescue => e
      my_logger.error("Unable to get catalogs info from kmedia , #{e.message}")
    end
    retrieved_catalogs
  end
end