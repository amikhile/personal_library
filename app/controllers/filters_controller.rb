class FiltersController < ApplicationController
  load_and_authorize_resource
  before_filter :load_filters_and_labels, :load_from_kmedia

  def index
    @filters = @filters.order(:id).page(params[:page])
  end

  def for_menu
    @filters = @filters.order(:id).page(params[:page])
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
      redirect_to inbox_files_path, :notice => "Filter Successfully created"
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
    if @filter.save
      redirect_to filter_path(@filter), :notice => "Filter was Successfully updated"
    else
      render :action => 'edit'
    end
  end

  def kmedia_catalogs
    catalog_id = params[:catalog_id]
    token = KmediaToken.get_token
    response = RestClient.post "#{APP_CONFIG['kmedia_url']}/admin/api/api/catalogs.json",
                               :auth_token => token, :content_type => :json, :root => catalog_id
    hash = JSON.parse response
    tree = transform_for_tree(hash['item'])
    render json: tree.to_json
  end


  private

  def transform_for_tree(catalogs)
    catalogs.map { |c|
      {
        :data => c['name'],
        :attr => {:id => c['id']},
        :state => "closed",
      }
    }
  end


  def load_filters_and_labels
    @filters_for_menu = current_user.filters.order(:name)
    @labels_for_menu = current_user.labels.order(:name)
  end

  def load_from_kmedia
    @content_types = ContentType.get_content_types.map { |ct| [ct['name'], ct['id']] }
    @media_types = MediaType.get_media_types.map { |mt| [mt['name'], mt['id']] }
    @languages = Language.get_languages.map { |l| [l['name'], l['id']] }
  #  @catalogs = catalogs
    t="j"
  end


end