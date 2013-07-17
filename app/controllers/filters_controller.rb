class FiltersController < ApplicationController
  load_and_authorize_resource
  before_filter :load_from_kmedia

  def index
    @filters = current_user.filters.order(:id).page(params[:page])
  end

  def new
    @filter = Filter.new
    authorize! :new, @filter
  end

  def create
    @filter = Filter.new
    authorize! :create, @filter

    @filter.attributes=params[:filter]
    @filter.catalogs=params[:selected_catalogs]
    @filter.users << current_user
    if @filter.save
      redirect_to filters_path, :notice => "Filter Successfully created"
    end
  end

  def show
    begin
      @filter = Filter.find(params[:id])
      authorize! :show, @filter
    rescue
      redirect_to filters_path, :alert => "There is no Filter with ID=#{params[:id]}."
      return
    end
  end

  def update
    @filter = Filter.find(params[:id])
    authorize! :update, @filter

    @filter.attributes = params[:filter]
    @filter.catalogs=params[:selected_catalogs]
    @filter.users << current_user unless @filter.users.include? current_user
    @filter.last_sync=nil
    if @filter.save
      redirect_to filter_path(@filter), :notice => "Filter was Successfully updated"
    else
      render :action => 'edit'
    end
  end

  def export
    authorize! :index, Filter
    filter = Filter.find(params[:id])
    files = InboxFile.joins(:kmedia_file).where("filter_id" => filter.id).multipluck(:name, :url) rescue []
    export_to_file(files, filter.name)
  end


  def kmedia_catalogs
    catalog_id = params[:catalog_id]
    selected_catalogs = Filter.find(params[:filter_id]).catalogs.split(",") rescue []
    token = KmediaToken.get_token
    response = RestClient.post "#{APP_CONFIG['kmedia_url']}/admin/api/api/catalogs.json",
                               :auth_token => token, :content_type => :json, :root => catalog_id
    hash = JSON.parse response
    retrieved_catalogs =  hash['item'].sort_by{|e| e['name']}
    tree = transform_for_tree(retrieved_catalogs, selected_catalogs)
    render json: tree.to_json
  end

  def destroy
    @filter = Filter.find(params[:id])
    authorize! :destroy, @filter
    @filter.inbox_files.each(&:destroy)
    @filter.destroy
    redirect_to filters_url, :notice => "Filter deleted successfully."
  end

  private

  def transform_for_tree(catalogs, selected_catalogs)
    catalogs.map { |c|
      {
          :data => c['name'],
          :attr => {:id => c['id'], :class => get_checked(c['id'], selected_catalogs)},
          :state => "closed",
      }
    }
  end

  def get_checked(catalog_id, selected_ids)
    css_class = "jstree-unchecked"
    css_class = "jstree-checked" if selected_ids.include? catalog_id.to_s()
    css_class
  end


end