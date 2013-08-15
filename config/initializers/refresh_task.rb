scheduler = Rufus::Scheduler.start_new


def self.my_logger
  @@my_logger ||= Logger.new("#{Rails.root}/log/files_sync_job.log")
end


#scheduler.every("10m") do
#auto run every day at 8 in the morning
scheduler.cron("0 8 * * *") do
  begin
    SyncAllFiltersJob.sync_all
  rescue => e
    my_logger.error("Unable to synchronize all filters", e)
  end
end 