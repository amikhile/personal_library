class FiltersController < ApplicationController
  load_and_authorize_resource
  before_filter :load_filters_and_labels

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
    @filter.users <<  current_user unless @filter.users.include? current_user
    if @filter.save
      redirect_to filter_path(@filter), :notice => "Filter was Successfully updated"
    else
      render :action => 'edit'
    end
  end

  protected
  def load_filters_and_labels
    @filters_for_menu = current_user.filters.order(:name)
    @labels_for_menu =  current_user.labels.order(:name)
  end

end