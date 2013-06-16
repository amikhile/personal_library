class DownloadTasksController < ApplicationController
  load_and_authorize_resource


  def index
    @tasks = current_user.download_tasks.order(:ready).page(params[:page])
  end

  def download
    @task = DownloadTask.find(params[:id])
    zip_file = "#{Rails.root}/zips/#{@task.zip_name}"
    send_file zip_file, :type=>"application/zip", :x_sendfile=>true
  end
end