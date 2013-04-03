class FilesSyncJob < Struct.new(:filter_id, :secure)


  def perform
    file_ids = get_file_ids_from_kmedia(filter_id)
    ids_of_files_to_fetch = check_existence(file_ids) unless file_ids.blank?
    get_the_new_files_from_kmedia(ids_of_files_to_fetch, secure) unless ids_of_files_to_fetch.blank?
    update_filter_last_sync
  end

  def my_logger
    @@my_logger ||= Logger.new("#{Rails.root}/log/files_sync_job.log")
  end

  private

  def update_filter_last_sync
    @filter.last_sync=DateTime.now
    @filter.save
  end

  def save_files(files)
    files.each { |f|
      file = KmediaFile.new()
      file.name= f['name']
      file.date= f['date']
      file.url= f['url']
      file.kmedia_id= f['id']

      inbox_file = InboxFile.new()
      inbox_file.kmedia_file = file
      inbox_file.filter_id = @filter.id

      file.save
      inbox_file.save
    }
  end

  def get_the_new_files_from_kmedia(ids_of_files_to_fetch, secure)
    ids_of_files_to_fetch.each_slice(100) do |ids_chunk|
      response = RestClient.post "#{APP_CONFIG['kmedia_url']}/admin/api/api/files.json",
                                 auth_token: @token,
                                 ids: ids_chunk.join(","),
                                 secure: secure
      hash = JSON.parse response
      files = hash['item']
      save_files(files)
    end
  end


  def check_existence(file_ids_string)
    ids = file_ids_string.split(",").flatten
    new_files_id=[]
    ids.each do |id|
      file = KmediaFile.find_by_kmedia_id(id)
      if (file)
        check_filter_association(file)
      else
        new_files_id << id
      end
    end
    my_logger.info("Found #{new_files_id.size} new files. New file ids are #{new_files_id} for filter #{@filter.name}")
    new_files_id
  end

  def check_filter_association(file)
    filter_file = InboxFile.where("kmedia_file_id = ? AND filter_id = ?", file.id, filter_id).first rescue nil
    if (filter_file.nil?)
      inbox_file = InboxFile.new
      inbox_file.kmedia_file = file
      inbox_file.filter_id = filter_id
      inbox_file.save
    end
  end

  def get_file_ids_from_kmedia(filter_id)

    @token = KmediaToken.get_token
    @filter = Filter.find_by_id(filter_id)
    my_logger.info("Syncronizing files for filter #{@filter.name}")
    content_type_ids = @filter.content_types.collect(&:kmedia_id).join(",")
    media_type_ids = @filter.media_types.collect(&:kmedia_id).join(",")
    languages_ids = @filter.languages.collect(&:kmedia_id).join(",")
    response = RestClient.post "#{APP_CONFIG['kmedia_url']}/admin/api/api/file_ids.json",
                               :auth_token => @token, :content_type_ids => content_type_ids, :catalog_ids => @filter.catalogs,
                               :from_date => @filter.from_date, :to_date => @filter.to_date, :media_type_ids => media_type_ids,
                               :lang_ids => languages_ids, :query_string => @filter.text, :created_from_date => @filter.last_sync


    hash = JSON.parse response
    ids = hash['ids']
    my_logger.info("Found #{ids.size} ids. Retrieved ids #{ids} for filter #{@filter.name}")
    ids
  end


  #def get_files_from_kmedia(filter_id)
  #
  #  token = KmediaToken.get_token
  #  filter = Filter.find_by_id(filter_id)
  #
  #  response = RestClient.post "#{APP_CONFIG['kmedia_url']}/admin/api/api/files.json",
  #                             :auth_token => token, :content_type => :json, :catalogs => filter.catalogs
  #
  #  hash = JSON.parse response
  #  files = hash['item']
  #end
end