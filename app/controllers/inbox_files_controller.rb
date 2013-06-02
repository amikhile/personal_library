class InboxFilesController < ApplicationController
  require 'rest_client'
  require 'json'
  load_resource
  before_filter :load_filters_and_labels


  def index
    authorize! :index, InboxFile
    init_cookies
    if (@filter)
      sync_with_kmedia(@filter) if Filter.find_by_id(@filter).last_sync.nil?
      @inbox_files = InboxFile.where("filter_id" => @filter).order(:id).page(params[:page])
    elsif (@label)
      @inbox_files = InboxFile.joins(:labels).where("labels.id" => @label).order(:id).page(params[:page])
    else
      @filters_for_menu.each do |filter|
        sync_with_kmedia(filter.id) if filter.last_sync.nil?
      end
      # inbox folder
      @inbox_files = InboxFile.not_archived.where("filter_id" => @filters_for_menu.collect(&:id)).order(:id).page(params[:page])
    end

  end


  def new
    @inbox_file= InboxFile.new
    authorize! :new, @inbox_file
  end

  def refresh
    authorize! :index, InboxFile
    if (@filter)
      sync_with_kmedia(@filter)
      redirect_to inbox_files_path
    else
      @filters_for_menu.each do |filter|
        sync_with_kmedia(filter.id)
      end
      redirect_to inbox_files_path
    end
  end

  def delete_multiple
    authorize! :destroy, InboxFile
    InboxFile.destroy_all(id: @ids)
    redirect_to inbox_files_path, notice: "Files deleted."
  end

  def archive_multiple
    authorize! :update, InboxFile
    InboxFile.update_all({archived: true}, ["id in (?)", @ids])
    redirect_to inbox_files_path, notice: "Files archived."
  end

  def download_multiple
    authorize! :index, InboxFile
    if @ids.present?
      task = DownloadTask.new()
      task.status = DownloadTask::STATUSES[:submitted]
      task.files = @ids.join(",")
      task.user = current_user
      task.save
    end
    redirect_to inbox_files_path
  end

  def add_label_multiple
    authorize! :update, InboxFile
    label = Label.find(params[:add_to_label])

    @ids.each do |id|
      file = InboxFile.find_by_id(id)
      file.labels << label unless file.labels.include?(label)
      file.save
    end

    redirect_to inbox_files_path, notice: "Files added to Label."
  end

  def remove_label
    authorize! :update, InboxFile
    @inbox_file = InboxFile.find(params[:fileid])
    @inbox_file.labels.delete(Label.find(params[:labelid]))
    @inbox_file.save
    render partial: 'name-td', locals: {inbox_file: @inbox_file}
  end

  def create
    @inbox_file = InboxFile.new
    authorize! :create, @inbox_file

    @inbox_file.attributes = params[:inbox_file]

    if @inbox_file.save
      redirect_to inbox_files_path, notice: "File Successfully created"
    end
  end

  def show
    begin
      @inbox_file = InboxFile.find(params[:id])
      authorize! :show, @inbox_file
    rescue
      redirect_to inbox_file_path, alert: "There is no File with ID=#{params[:id]}."
      return
    end
  end

  def update
    @inbox_file = InboxFile.find(params[:id])
    authorize! :update, @inbox_file
    if @inbox_file.update_attributes(params[:inbox_file])
      redirect_to inbox_files_path, notice: "File updated."
    else
      render :action => 'edit'
    end
  end

  def description
    @inbox_file = InboxFile.find(params[:id])
    authorize! :update, @inbox_file

    @inbox_file.description = params[:value]
    @inbox_file.save
    redirect_to inbox_files_path
  end

  def archive
    @inbox_file = InboxFile.find(params[:id])
    authorize! :update, @inbox_file
    @inbox_file.archived = params[:archived]
    @inbox_file.save

    redirect_to inbox_files_path, notice: "File archived."

  end

  def destroy
    @inbox_file = InboxFile.find(params[:id])
    authorize! :destroy, @inbox_file
    @inbox_file.destroy

    redirect_to inbox_files_path, notice: "File deleted."


  end


  private

  def load_filters_and_labels
    @ids = params[:selected_files].split(",") rescue []
    @filters_for_menu = current_user.filters.order(:name)
    @labels_for_menu = current_user.labels.order(:name)
  end

  def init_cookies
    if (params[:filter])
      cookies.permanent[:filter] = params[:filter]
      cookies.permanent[:label] = nil
    elsif (params[:label])
      cookies.permanent[:filter] = nil
      cookies.permanent[:label] = params[:label]
    elsif (params[:inbox])
      cookies.permanent[:label] = nil
      cookies.permanent[:filter] = nil
    end
    @filter = cookies[:filter] if cookies[:filter].present?
    @label = cookies[:label] if cookies[:label].present?
  end

  def sync_with_kmedia(filter_id)
    job = FilesSyncJob.new(filter_id, secure)
    job.perform
  end


  def secure
    return 0 #if cannot?(:search_secure, KmediaFile)
  end

end