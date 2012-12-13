class InboxFilesController < ApplicationController
  require 'rest_client'
  require 'json'
  load_and_authorize_resource
  before_filter :load_filters_and_labels


  def index
    @files = InboxFile.order(:id).page(params[:page])
    token = get_kmedia_token
  end

  def new
    @file = InboxFile.new
    authorize! :new, @filter
  end

  def create
    @file = InboxFile.new
    authorize! :create, @file

    @file.attributes = params[:inbox_file]

    if @file.save
      redirect_to inbox_files_path, :notice => "File Successfully created"
    end
  end

  def show
    begin
      @file = InboxFile.find(params[:id])
      authorize! :show, @file
    rescue
      redirect_to inbox_file_path, :alert => "There is no File with ID=#{params[:id]}."
      return
    end
  end

  def update
    @file = InboxFile.find(params[:id])
    authorize! :update, @file

    @file.attributes = params[:inbox_file]
    if @file.save
      redirect_to filter_path(@file), :notice => "File was Successfully updated"
    else
      render :action => 'edit'
    end
  end

  protected
  def load_filters_and_labels
    @filters_for_menu = current_user.filters.order(:name)
    @labels_for_menu =  current_user.labels.order(:name)
  end


  private

  def get_kmedia_token

    #response = RestClient.post 'http://localhost:4000/admin/api/tokens.json',
    #                           :email => 'ana@email.com', :password => '123456', :content_type => :json

    response = RestClient.post 'http://kmedia.kbb1.com/admin/api/tokens.json',
                               :email => 'annamik@gmail.com', :password => 'mili10', :content_type => :json

    hash = JSON.parse response
    token = hash['token']

  end


end