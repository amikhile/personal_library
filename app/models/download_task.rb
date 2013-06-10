class DownloadTask < ActiveRecord::Base

  belongs_to :user


  STATUSES = {submitted: "submitted", progress: 'progress', complete: 'complete'}

  def update_status(status_to_set)
    self.status = status_to_set
    self.ready = Time.new if status_to_set==STATUSES[:complete]
    save
  end

end