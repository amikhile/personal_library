class FilesDownloadJob < Struct.new(:task)

  require 'open-uri'
  require 'zip/zip'
  require 'securerandom'

  def perform
    task.update_status(DownloadTask::STATUSES[:progress])
    download
    prepare_zip
    task.update_status(DownloadTask::STATUSES[:complete])
  end


  def prepare_zip
    my_logger.info("Download task #{task.zip_name}. finished... preparing the zip")
    @zips_folder = FileUtils.mkdir_p("#{Rails.root}/zips")[0]
    zip_filepath = "#{@zips_folder}/#{task.zip_name}"
    FileUtils.rm zip_filepath, :force => true
    Zip::ZipFile.open(zip_filepath, Zip::ZipFile::CREATE) { |zipfile|
      Dir.foreach(@download_folder) do |item|
        item_path = "#{@download_folder}/#{item}"
        zipfile.add(item, item_path) if File.file? item_path
      end
    }
    my_logger.info("Zip file is ready for task #{task.zip_name}.")
    File.chmod(0644, zip_filepath)
    FileUtils.rm_rf @download_folder
  end

  def download
    my_logger.info("Processing download task #{task.zip_name}.")
    @download_folder = FileUtils.mkdir_p("#{Rails.root}/downloads/#{task.user_id}/#{task.zip_name}")[0]

    inbox_files_ids = task.files.split(",") rescue []
    inbox_files_ids.each do |id|
      kmedia_file = InboxFile.find(id).kmedia_file
      download_file(kmedia_file)
    end

  end

  def download_file(kmedia_file)
    store_file = File.join(@download_folder, kmedia_file.name)
    # wb , w for write permissions , b for binary
    open(store_file, 'wb') do |file|
      file << open(kmedia_file.url).read
      my_logger.info("File #{kmedia_file.name} Downloaded.")
    end
  end

  def my_logger
    @@my_logger ||= Logger.new("#{Rails.root}/log/files_download_job.log")
  end

end