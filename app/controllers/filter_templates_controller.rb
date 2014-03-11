class FilterTemplatesController < ApplicationController
  load_and_authorize_resource
  before_filter :load_from_kmedia

  def index
    @filters = FilterTemplate.order(:id).page(params[:page])
  end


  def new
    @filter = FilterTemplate.new
    authorize! :new, @filter

    MAIN_LANGS.each { |l|
      @filter.filter_template_names.build(:code3 => l)
    }

    @filter_names = @filter.filter_template_names
  end

  def edit
    @filter = FilterTemplate.find(params[:id])
    authorize! :update, @filter
  end

  def create
    @filter = FilterTemplate.new
    authorize! :create, @filter

    @filter.attributes = params[:filter_template]
    @filter.catalogs = params[:selected_catalogs]
    if @filter.save
      redirect_to filter_templates_path, notice: t('messages.template_created_successfull', name: @filter.name)
    end
  end


  def show
    begin
      @filter = FilterTemplate.find(params[:id])
      authorize! :show, @filter
    rescue
      redirect_to filter_templates_path, alert: "There is no Recommended Filter with id=#{params[:id]}."
    end
  end

  def update
    @filter = FilterTemplate.find(params[:id])
    authorize! :update, @filter

    @filter.attributes = params[:filter]
    @filter.catalogs = params[:selected_catalogs]
    if @filter.save
      redirect_to filter_templates_path, notice: t('messages.template_updated_successfull', name: @filter.name)
    else
      render action: 'edit'
    end
  end


  def kmedia_catalogs
    retrieved_catalogs = KmediaClient.get_catalogs_from_kmedia(root: params[:catalog_id])
    selected_catalogs = FilterTemplate.find(params[:filter_id]).catalogs.split(",") rescue []
    tree = transform_for_tree(retrieved_catalogs, selected_catalogs)
    render json: tree.to_json
  end

  def destroy
    @filter = FilterTemplate.find(params[:id])
    authorize! :destroy, @filter
    @filter.destroy
    redirect_to filter_templates_path, notice: t('messages.template_deleted_successfull', name: @filter.name)
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