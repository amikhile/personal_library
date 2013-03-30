class InboxFilesController < ApplicationController
  require 'rest_client'
  require 'json'
  load_and_authorize_resource
  before_filter :load_filters_and_labels


  def index
    authorize! :index, InboxFile
    @filter = params[:filter]
    if (@filter)
      sync_with_kmedia(@filter) if Filter.find_by_id(@filter).last_sync.nil?
      @inbox_files = InboxFile.joins(:filters).where("filters.id" => @filter).order(:id).page(params[:page])
    else
      @filters_for_menu.each do |filter|
        sync_with_kmedia(filter.id) if filter.last_sync.nil?
      end
      # inbox folder
      @inbox_files = InboxFile.not_archived.joins(:filters).where("filters.id" => @filters_for_menu.collect(&:id)).order(:id).page(params[:page])
    end

  end

  def new
    @inbox_file= InboxFile.new
    authorize! :new, @inbox_file
  end

  def refresh
    authorize! :index, InboxFile
    @filter = params[:filter]
    if (@filter)
      sync_with_kmedia(@filter)
    else
      @filters_for_menu.each do |filter|
        sync_with_kmedia(filter.id)
      end
    end
    redirect_to inbox_files_path
  end

  def create
    @inbox_file = InboxFile.new
    authorize! :create, @inbox_file

    @inbox_file.attributes = params[:inbox_file]

    if @inbox_file.save
      redirect_to inbox_files_path, :notice => "File Successfully created"
    end
  end

  def show
    begin
      @inbox_file = InboxFile.find(params[:id])
      authorize! :show, @inbox_file
    rescue
      redirect_to inbox_file_path, :alert => "There is no File with ID=#{params[:id]}."
      return
    end
  end

  def update
    @inbox_file = InboxFile.find(params[:id])
    authorize! :update, @inbox_file

    if @inbox_file.update_attributes(params[:inbox_file])
      redirect_to filter_path(@inbox_file), :notice => "File was Successfully updated"
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
    redirect_to inbox_files_path
  end

  def destroy
    @inbox_file = InboxFile.find(params[:id])
    authorize! :destroy, @inbox_file
    @inbox_file.destroy
    redirect_to inbox_files_path, :notice => "File deleted."
  end


  private

  def load_filters_and_labels
    @filters_for_menu = current_user.filters.order(:name)
    @labels_for_menu = current_user.labels.order(:name)
  end


  def sync_with_kmedia(filter_id)
    job = FilesSyncJob.new(filter_id, secure)
    job.perform
  end


  def secure
    return 0 if cannot?(:search_secure, KmediaFile)
    4
  end

end