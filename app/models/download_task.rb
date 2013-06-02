class DownloadTask < ActiveRecord::Base

  belongs_to :user


  STATUSES = {submitted: "submitted", progress: 'progress', complete: 'complete'}

end