class SyncAllFiltersJob

  def self.my_logger
    @@my_logger ||= Logger.new("#{Rails.root}/log/files_sync_job.log", 10, 10.megabytes)
  end

  def self.sync_all
    my_logger.info("######################## Synchronizing files for all filters ###############################")
    filters_id = Filter.pluck(:id)
    filters_id.each do |id|
      begin
        job = FilesSyncJob.new(id, 0)
        job.perform
      rescue => e
        my_logger.error("Unable to synchronize filter [#{id}] , #{e.message}" )
      end
    end
  end


end